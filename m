Return-Path: <SRS0=7U0C=FU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EC8C4361B
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Dec 2020 05:43:29 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7596C23123
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Dec 2020 05:43:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7596C23123
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D3EE8100ED499;
	Tue, 15 Dec 2020 21:43:27 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=156.151.31.86; helo=userp2130.oracle.com; envelope-from=jane.chu@oracle.com; receiver=<UNKNOWN> 
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E5C33100EF275
	for <linux-nvdimm@lists.01.org>; Tue, 15 Dec 2020 21:43:24 -0800 (PST)
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BG5ecQf172932;
	Wed, 16 Dec 2020 05:43:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=T8VJpldCNi+sj6YW08esJ7EhQP7RkcOTlE+MlH6mYLs=;
 b=K5A3QJWodrZBH11uy941tRO6n38iCfy9Czcb7m/MrxhOmWZ3LtNOzj5vrynmZILAFi3C
 o/hBnV8lvTjP95xcdUi2MQqBPRED1ZX8HrGP3mgTO0VaKk49d0oxJdEXrzCmn2WpsevR
 +TKf3vheZaSiHrSF24Jt2/I39qoaraAeIkdbVXRS0prYxUdje7qgYmuOn2TTXv4HXzjE
 zeKrcD4mKuaI2/OXeWyhr/soaSXYHVvz+tqfcvXgUaPqICHwWGgcuyiRquHStTwcTb0m
 7ct+CSzEd6nyCOeJfd9JtpUa/liMsJ9oJqj6TuBsp9LcHVyhraWlR1OYP0ij4CGAf2ZV 7g==
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 35cn9re4ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Dec 2020 05:43:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BG5f9TG060072;
	Wed, 16 Dec 2020 05:43:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userp3020.oracle.com with ESMTP id 35e6js8pa1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Dec 2020 05:43:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BG5hAp8001000;
	Wed, 16 Dec 2020 05:43:10 GMT
Received: from [10.159.136.92] (/10.159.136.92)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Tue, 15 Dec 2020 21:43:10 -0800
Subject: Re: [RFC PATCH v3 8/9] md: Implement ->corrupted_range()
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-mm@kvack.org
References: <20201215121414.253660-1-ruansy.fnst@cn.fujitsu.com>
 <20201215121414.253660-9-ruansy.fnst@cn.fujitsu.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <100fcdf4-b2fe-d77d-e95f-52a7323d7ee1@oracle.com>
Date: Tue, 15 Dec 2020 21:43:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201215121414.253660-9-ruansy.fnst@cn.fujitsu.com>
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160035
Message-ID-Hash: 7CAZXCFZKJMT4YIBUKWZ7V3E2GZ4FRWG
X-Message-ID-Hash: 7CAZXCFZKJMT4YIBUKWZ7V3E2GZ4FRWG
X-MailFrom: jane.chu@oracle.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, hch@lst.de, song@kernel.org, rgoldwyn@suse.de, qi.fuli@fujitsu.com, y-goto@fujitsu.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/7CAZXCFZKJMT4YIBUKWZ7V3E2GZ4FRWG/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit

On 12/15/2020 4:14 AM, Shiyang Ruan wrote:
>   #ifdef CONFIG_SYSFS
> +int bd_disk_holder_corrupted_range(struct block_device *bdev, loff_t off,
> +				   size_t len, void *data);
>   int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
>   void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk);
>   #else
> +int bd_disk_holder_corrupted_range(struct block_device *bdev, loff_t off,

Did you mean
   static inline int bd_disk_holder_corrupted_range(..
?

thanks,
-jane

> +				   size_t len, void *data)
> +{
> +	return 0;
> +}
>   static inline int bd_link_disk_holder(struct block_device *bdev,
>   				      struct gendisk *disk)
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
