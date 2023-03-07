"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const client_s3_1 = require("@aws-sdk/client-s3");
// ghealth
const health = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    console.log(`health`);
    return res.status(200).json({
        data: 'healthy'
    });
});
// getting all files
const getFiles = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    console.log(`getFiles`);
    const client = new client_s3_1.S3Client({ region: "us-east-2" });
    const command = new client_s3_1.ListObjectsCommand({ Bucket: "clinicalfiles" });
    client.send(command)
        .then((data) => {
        var _a;
        return res.status(200).json({
            data: (_a = data.Contents) === null || _a === void 0 ? void 0 : _a.map((i) => i.Key)
        });
    })
        .catch((error) => {
        return res.status(400).json({
            error,
        });
    });
});
const streamToString = (stream) => new Promise((resolve, reject) => {
    const chunks = [];
    stream.on('data', (chunk) => chunks.push(chunk));
    stream.on('error', reject);
    stream.on('end', () => resolve(Buffer.concat(chunks).toString('utf8')));
});
function isFileExist(id) {
    return __awaiter(this, void 0, void 0, function* () {
        const client = new client_s3_1.S3Client({ region: "us-east-2" });
        const command = new client_s3_1.GetObjectAttributesCommand({ Bucket: "clinicalfiles", Key: id, ObjectAttributes: ["ObjectSize"] });
        try {
            yield client.send(command);
            return true;
        }
        catch (err) {
            return false;
        }
    });
}
;
const getFile = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const id = req.params.id;
    console.log(`getFile id:${id}`);
    const client = new client_s3_1.S3Client({ region: "us-east-2" });
    const command = new client_s3_1.GetObjectCommand({ Bucket: "clinicalfiles", Key: id });
    client.send(command)
        .then((data) => {
        streamToString(data.Body)
            .then((data) => {
            return res.status(200).json({
                data
            });
        })
            .catch((error) => {
            return res.status(400).json({
                error,
            });
        });
    })
        .catch((error) => {
        return res.status(400).json({
            error,
        });
    });
});
const updateFile = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    const id = req.params.id;
    const data = (_a = req.body.data) !== null && _a !== void 0 ? _a : '';
    console.log(`updateFile id:${id} data:${data}`);
    const client = new client_s3_1.S3Client({ region: "us-east-2" });
    const command = new client_s3_1.PutObjectCommand({ Bucket: "clinicalfiles", Key: id, Body: data });
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
    });
});
const addFile = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    var _b;
    const id = req.body.id;
    const data = (_b = req.body.data) !== null && _b !== void 0 ? _b : '';
    console.log(`addFile id:${id} data:${data}`);
    const isExist = yield isFileExist(id);
    if (isExist) {
        return res.status(405).json({
            error: "file allready exist",
        });
    }
    const client = new client_s3_1.S3Client({ region: "us-east-2" });
    const command = new client_s3_1.PutObjectCommand({ Bucket: "clinicalfiles", Key: id, Body: data });
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
    });
});
exports.default = { health, getFiles, getFile, updateFile, addFile };
