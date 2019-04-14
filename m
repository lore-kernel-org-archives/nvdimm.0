Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
 [148.163.143.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2AFEF211EC0DE
 for <linux-nvdimm@lists.01.org>; Sat, 13 Apr 2019 20:21:04 -0700 (PDT)
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: [PATCH][RFC] nvdimm: pmem: always flush nvdimm for write request
Date: Sun, 14 Apr 2019 03:20:54 +0000
Message-ID: <AT5PR8401MB11694F5888BCE7133F1FDD4FAB2A0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1555051638-32354-1-git-send-email-lirongqing@baidu.com>,
 <CAPcyv4hD9rwFHyEh=5gAWe0JPwzUJqUTi4FaUkyLtyovE==U1w@mail.gmail.com>
 <46ecaf420d664ebfab035e8202a774a9@baidu.com>
In-Reply-To: <46ecaf420d664ebfab035e8202a774a9@baidu.com>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Li,Rongqing" <lirongqing@baidu.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



>> @@ -215,7 +216,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
>> 	if (do_acct)
>> 		nd_iostat_end(bio, start);
>> 
>> -	if (bio->bi_opf & REQ_FUA)
>> +	if (bio->bi_opf & REQ_FUA || op_is_write(op))
>>  		nvdimm_flush(nd_region);
...
>> Before:
>> Jobs: 32 (f=32): [W(32)][14.2%][w=1884MiB/s][w=482k IOPS][eta 01m:43s]
>> After:
>> Jobs: 32 (f=32): [W(32)][8.3%][w=2378MiB/s][w=609k IOPS][eta 01m:50s]
>>
>> -RongQing


Doing more work cannot be faster than doing less work, so something else
must be happening here.

Please post the full fio job file and how you invoke it (i.e., with numactl).

These tools help show what is happening on the CPUs and memory channels:
    perf top
    pcm.x
    pcm-memory.x -pmm


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
