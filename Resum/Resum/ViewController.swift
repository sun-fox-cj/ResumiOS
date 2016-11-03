//
//  ViewController.swift
//  Resum
//
//  Created by cjfire on 2016/10/28.
//  Copyright © 2016年 cjfire. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {
    
    lazy var manager: AFHTTPSessionManager = {
        
        let manager = AFHTTPSessionManager()
        
        return manager;
    }()
    
    lazy var session: URLSession = {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }()
    
    var task: URLSessionDownloadTask?
    var resumeData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let address = "http://192.168.8.112/"
        let path = "DownloadFile/index.php"
        
        let url = URL(string: address + path)
        var req = URLRequest(url: url!)
        req.timeoutInterval = 15
        req.addValue("0-", forHTTPHeaderField: "Range")
        
//        task = manager.downloadTask(with: req, progress: { (progress) in
//            print(progress)
//        }, destination: { (url, response) -> URL in
//            print(url, response)
//            
//            return URL(string: "www.baidu.com")!
//            
//        }, completionHandler: { (response, url, error) in
//            print(response, url, error)
//        })
        
//        task?.resume()
        
//        task = manager.get(address + path, parameters: nil, progress: { progress in
//        
//            print(progress)
//        }, success: { dataTask, json in
//            
//            
//        }, failure: { dataTask, error in
//        
//        })
        
        task = session.downloadTask(with: req)
//        task = session.dataTask(with: url!)
    }

    deinit {
        session.invalidateAndCancel()
    }
    
    @IBAction func resume(_ sender: UIBarButtonItem) {
        
        if resumeData != nil {
            self.task = self.session.downloadTask(withResumeData: self.resumeData!)
            self.resumeData = nil
        }
        
        if task?.state != .running {
            task?.resume()
        }
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//            self.task?.suspend()
//        })
    }
    
    @IBAction func stop(_ sender: UIBarButtonItem) {
//        task?.suspend()
        
//        (task as! URLSessionDownloadTask).cancel { (data) in
//            self.resumeData = data
//        }
        
        task?.cancel(byProducingResumeData: { data in
            self.resumeData = data
            
            print("这里是不是空的 \(data?.count)")
        })
        
    }
    
    
    var count = 0
}

extension ViewController: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        print(response)
        
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        count += data.count
        
        print(count)
        print("~~~~~")
        
//        let a = String(data: data, encoding: String.Encoding.utf8)
        
//        print(a)
    }
}

extension ViewController: URLSessionTaskDelegate {
    
}

extension ViewController: URLSessionDownloadDelegate {
    
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
        print(expectedTotalBytes)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print(location)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        print(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
        print(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
    }
    
    
}
