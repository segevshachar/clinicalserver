import { Request, Response, NextFunction } from 'express';
import axios, { AxiosResponse } from 'axios';
import { S3Client, GetObjectCommand, ListObjectsCommand, PutObjectCommand, GetObjectAttributesCommand } from "@aws-sdk/client-s3";


// ghealth
const health = async (req: Request, res: Response, next: NextFunction) => {
  console.log(`health`);

  return res.status(200).json({
    data: 'healthy'
  });
}


// getting all files
const getFiles = async (req: Request, res: Response, next: NextFunction) => {
  console.log(`getFiles`);

  const client = new S3Client({ region: "us-east-2" });
  const command = new ListObjectsCommand({ Bucket: "clinicalfiles" });
  client.send(command)
    .then((data) => {
      return res.status(200).json({
        data: data.Contents?.map((i) => i.Key)
      });
    })
    .catch((error) => {
      return res.status(400).json({
        error,
      });
    })
};


const streamToString = (stream: any) => new Promise((resolve, reject) => {
  const chunks: any[] = [];
  stream.on('data', (chunk: any) => chunks.push(chunk));
  stream.on('error', reject);
  stream.on('end', () => resolve(Buffer.concat(chunks).toString('utf8')));
});


async function isFileExist(id: string): Promise<boolean> {
  const client = new S3Client({ region: "us-east-2" });
  const command = new GetObjectAttributesCommand({ Bucket: "clinicalfiles", Key: id, ObjectAttributes: ["ObjectSize"] });
  try {
    await client.send(command);
    return true;
  }
  catch (err) {
    return false;
  }
};


const getFile = async (req: Request, res: Response, next: NextFunction) => {
  const id: string = req.params.id;

  console.log(`getFile id:${id}`);

  const client = new S3Client({ region: "us-east-2" });
  const command = new GetObjectCommand({ Bucket: "clinicalfiles", Key: id });
  client.send(command)
    .then((data) => {
      streamToString(data.Body)
        .then((data) => {
          return res.status(200).json({
            data
          })
        })
        .catch((error) => {
          return res.status(400).json({
            error,
          });
        })
    })
    .catch((error) => {
      return res.status(400).json({
        error,
      });
    })
};


const updateFile = async (req: Request, res: Response, next: NextFunction) => {
  const id: string = req.params.id;
  const data: string = req.body.data ?? '';

  console.log(`updateFile id:${id} data:${data}`);
  const client = new S3Client({ region: "us-east-2" });
  const command = new PutObjectCommand({ Bucket: "clinicalfiles", Key: id, Body: data });
  client.send(command)
    .then((data) => {
      return res.status(200).json({
        data: data.$metadata.httpStatusCode
      });
    })
    .catch((error) => {
      return res.status(400).json({
        error,
      });
    })
};


const addFile = async (req: Request, res: Response, next: NextFunction) => {

  const id: string = req.body.id;
  const data: string = req.body.data ?? '';

  console.log(`addFile id:${id} data:${data}`);

  const isExist = await isFileExist(id);
  if (isExist) {
    return res.status(405).json({
      error: "file allready exist",
    });
  }

  const client = new S3Client({ region: "us-east-2" });
  const command = new PutObjectCommand({ Bucket: "clinicalfiles", Key: id, Body: data });
  client.send(command)
    .then((data) => {
      return res.status(200).json({
        data: data.$metadata.httpStatusCode
      });
    })
    .catch((error) => {
      return res.status(400).json({
        error,
      });
    })
};

export default { health, getFiles, getFile, updateFile, addFile };
