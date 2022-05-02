Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DC117C1
	for <nvdimm@lists.linux.dev>; Mon,  2 May 2022 09:33:50 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2426n4u8025008;
	Mon, 2 May 2022 09:33:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/jywOcdWvDzAIx+1jdlo87HJXiCqFfBByL/uqmnNid0=;
 b=WuOT0x8uQG3/+sm1K8e/zpdf9KnPUFsJoDBId/YLkd4uvCnmz1Y17D8R4NgXlLX94RsC
 W6WkUWIhIL6az9OAWej1X2PiXWctTWxXu8AnAU8XGVvBviiqH4OG+oLQsHcqsuc2+2AX
 /R7L3oOIQQThgBQnd2VNPP5A7WhGU0dauPj7tEDpSqxAoiuQikmy1Mz6dkT0UJvWSanm
 dg7e+AfMMTJJiZdm4hoZl9431Wk33EHYehB1XxH6LWXZyD4inpJc/mfpinl6ChajVUzX
 8ewQ7+QvIArvgqYwuv/8AQ8pE/67swJWvMILOK+0Z9AhShPw1WKTsqxTGRKSCS0teD5J qQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fsef6qpe0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 May 2022 09:33:49 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2429SH6r015533;
	Mon, 2 May 2022 09:33:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma06ams.nl.ibm.com with ESMTP id 3frvcj2g2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 May 2022 09:33:46 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2429XiVx39715174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 May 2022 09:33:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E650AE053;
	Mon,  2 May 2022 09:33:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E2BDAE056;
	Mon,  2 May 2022 09:33:43 +0000 (GMT)
Received: from [9.43.11.32] (unknown [9.43.11.32])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon,  2 May 2022 09:33:43 +0000 (GMT)
Message-ID: <1fa2de28-7bbb-f584-ec11-2cf320dfea39@linux.ibm.com>
Date: Mon, 2 May 2022 15:03:41 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] test: monitor: Use in-tree configuration file
Content-Language: en-US
To: Michal Suchanek <msuchanek@suse.de>, nvdimm@lists.linux.dev
References: <20220428190831.15251-1-msuchanek@suse.de>
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20220428190831.15251-1-msuchanek@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SSQ5VDeyK1Qf_wN8tO6Ga9ewtOLfinXK
X-Proofpoint-ORIG-GUID: SSQ5VDeyK1Qf_wN8tO6Ga9ewtOLfinXK
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_03,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020074

On 4/29/22 00:38, Michal Suchanek wrote:
> When ndctl is not installed /etc/ndctl.conf.d does not exist and the
> monitor fails to start. Use in-tree configuration for testing.
> 
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>   test/monitor.sh | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/test/monitor.sh b/test/monitor.sh
> index e58c908..c5beb2c 100755
> --- a/test/monitor.sh
> +++ b/test/monitor.sh
> @@ -13,6 +13,8 @@ smart_supported_bus=""
>   
>   . $(dirname $0)/common
>   
> +monitor_conf="$TEST_PATH/../ndctl"

Though this patch gets the monitor to "listening" mode,
its not really parsing anything from the $TEST_PATH/../ndctl

There are two issues here.
1) Using the iniparser for parsing the monitor config file
when the parser is set to parse_monitor_config() for monitor.
I have posted a patch for this at 
https://patchwork.kernel.org/project/linux-nvdimm/patch/164750955519.2000193.16903542741359443926.stgit@LAPTOP-TBQTPII8/

2) The directory passed in -c would silently be ignored
in parse_monitor_config() during fseek() failure. The command proceeds 
to monitor everything.

Should the -c option be made to accept the directory as argument?

Thanks,
Shivaprasad
