Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26D27F6
	for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 10:53:35 +0000 (UTC)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25K7i2BU024218;
	Mon, 20 Jun 2022 09:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=lez5hQYIMS5d6I4dl1KXmRCZrul+GCwIkuzX51xn8VA=;
 b=ZWqQXuzrJLAyE97elCOq2gFd1Stm1P6Dck/Y+WLFczUfn3bz8EGbVHV+llk7eciiJb1u
 KUiRKZ5a6ZvOITEYSNvJhc52ycuxfQ0rqYbXwmMsdBrusKDs2eYk1QLcdgVcxdbcH7dS
 Y72B/a9SFobB02Kq5JNujEbd9/pXPFv/6unCxydY519NH3pjO5kwHYce2RAPMjY7oKDe
 okL++TraHVWZvx4/8AgxUbhcFBOzgu4/Gu+C1vDXeXucNZLXNFhqbxFp6HFN/wq15AU9
 Eu3z/rjJqeY2hFUhntMzD6/IWjXVboF8qMO12CjNljmgJYgMrC4xF8abzuRTxTZk+lTH 4A== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsr4kc70m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jun 2022 09:27:58 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25K9L1CY001613;
	Mon, 20 Jun 2022 09:27:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma05fra.de.ibm.com with ESMTP id 3gs6b91sc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jun 2022 09:27:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25K9RrdU23331108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jun 2022 09:27:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E8D9A404D;
	Mon, 20 Jun 2022 09:27:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D2A5A4040;
	Mon, 20 Jun 2022 09:27:51 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com (unknown [9.43.91.113])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jun 2022 09:27:51 +0000 (GMT)
Message-ID: <b0a77e8039591027a469166b4a4e0b3fbd0faae3.camel@linux.ibm.com>
Subject: Re: [PATCH v4 0/2]ndctl/namespace: Fix and improve write-infoblock
From: Tarun Sahu <tsahu@linux.ibm.com>
Reply-To: tsahu@linux.ibm.com
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 20 Jun 2022 14:57:50 +0530
In-Reply-To: <20220527103021.452651-1-tsahu@linux.ibm.com>
References: <20220527103021.452651-1-tsahu@linux.ibm.com>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tfo4TwNwdm5IjuYcfZ8h9qz-1W2dloDL
X-Proofpoint-GUID: tfo4TwNwdm5IjuYcfZ8h9qz-1W2dloDL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1011 malwarescore=0 mlxlogscore=748 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200043

Hi, 

Just a gentle reminder. May you please look into these patches.
Please let me know if any changes are required.

Thanks
Tarun

On Fri, 2022-05-27 at 16:00 +0530, Tarun Sahu wrote:
> This series resolves some issues with write-infoblock 
> command and provide support to write-infoblock for sector 
> mode namespace
> 
> write-infoblock command has issues regarding updating the 
> align, uuid, parent_uuid. In case of no parameter passed 
> for it, this command used to overwrite the existing values 
> with defaults.
> 
> In PATCH 1/2 these parameters will be set to their original 
> values, incase, values hasn't been passed in command 
> arguments
> 
> write-infoblock command doesn't have support for sector/BTT 
> mode namespaces. They can be converted to fsdax, but can 
> not be written being in sector mode.
> 
> In PATCH 2/2, It creates a functionality which write 
> infoblock of Sector/BTT namespace. Currently only uuid, 
> parent_uuid can be updated. In future, Support for other 
> parameters can easily be integrated in the
> functionality.
> 
> ---
> v2:
>   Updated the commit message (rephrasing) in patch 1/2
>   Moved the ns_info struct to namespace.c from namespace.h
>   put the results after --- to avoid long commit message
> 
> v3:
>   reformat the commit message to meet 100 column condition
> 
> v4:
>   - Moved the struct ns_info definition to the beginning of
>   the block 
>   - Initialized the buf of ns_info structure in ns_info_init
>   - Change the format of comment in code from "//" to "/**/"
>   - reword the commit message of patch 2/2
> 
> Tarun Sahu (2):
>   ndctl/namespace: Fix multiple issues with write-infoblock
>   ndctl/namespace: Implement write-infoblock for sector mode
> namespaces
> 
>  ndctl/namespace.c | 314 ++++++++++++++++++++++++++++++++++----------
> --
>  1 file changed, 231 insertions(+), 83 deletions(-)
> 

