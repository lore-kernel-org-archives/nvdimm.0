Return-Path: <SRS0=z2MS=A3=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AB3C433E3
	for <linux-nvdimm@archiver.kernel.org>; Thu, 16 Jul 2020 19:04:25 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE1DE207FB
	for <linux-nvdimm@archiver.kernel.org>; Thu, 16 Jul 2020 19:04:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TBuQZ+bi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE1DE207FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C7BAB11571BF6;
	Thu, 16 Jul 2020 12:04:24 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=141.146.126.79; helo=aserp2130.oracle.com; envelope-from=joao.m.martins@oracle.com; receiver=<UNKNOWN> 
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DD04A11571BF2
	for <linux-nvdimm@lists.01.org>; Thu, 16 Jul 2020 12:04:22 -0700 (PDT)
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06GIvvdX093788;
	Thu, 16 Jul 2020 19:04:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=S9AUiDC5UbBVMWJx0Ds+Dd7RmziEgB45+Kho6l5plJ0=;
 b=TBuQZ+bibLwWnupgZh4L92p/mQ+Nc+oyUWq/OIC3C8KsQUQbxx4oqkXx2tlEjddRkx/I
 yBJHeg0YYuMnPVGwxs1lwBisIvVfM/33QTO80aKa+Y8KXf5yON+sglSnuKiZZXMiPLW1
 gRUMfCPalx+1rnJC1mb/edzNIgoE0UJQF2s1gCl8hgq8tZpHPQvHpnzsw4xhUs+ZLcxB
 phGLP5+MDNXUmkWVR0YGpF/Q64J/0B1ChXg0w2TsZXXd8n6kGL6mpAc9ZvHL5aPpK7oj
 q5JH30AwlQVRog+6bA2UFhmNsNTbSNWCi0sbl82u+I/ApEqlWwEj7vaVtVWS/RX0cFO6 6A==
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 327s65skdf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 16 Jul 2020 19:04:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06GIvnw2064117;
	Thu, 16 Jul 2020 19:04:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userp3020.oracle.com with ESMTP id 32akr3wys4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jul 2020 19:04:13 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06GJ4AgS010488;
	Thu, 16 Jul 2020 19:04:10 GMT
Received: from [10.175.173.87] (/10.175.173.87)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Thu, 16 Jul 2020 12:04:10 -0700
Subject: Re: [PATCH v2 22/22] device-dax: Introduce 'mapping' devices
To: Dan Williams <dan.j.williams@intel.com>
References: <159457116473.754248.7879464730875147365.stgit@dwillia2-desk3.amr.corp.intel.com>
 <159457128462.754248.10443613927921016089.stgit@dwillia2-desk3.amr.corp.intel.com>
 <7ecd1b82-06ab-be49-4b92-ac42caab146c@oracle.com>
 <CAPcyv4hFS7JS9s7cUY=2Ru2kUTRsesxwX1PGnnc_tudJjoDUGw@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <34b93713-6c45-4a0f-085b-289ba2ad6ce0@oracle.com>
Date: Thu, 16 Jul 2020 20:04:05 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hFS7JS9s7cUY=2Ru2kUTRsesxwX1PGnnc_tudJjoDUGw@mail.gmail.com>
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=100 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=-1000 spamscore=100 mlxscore=100 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=100 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=100 priorityscore=1501 lowpriorityscore=0
 spamscore=100 clxscore=1015 bulkscore=0 mlxlogscore=-1000 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160132
Message-ID-Hash: QJ6376A2ULSLG3SS64DYLGRIL53BJ3GK
X-Message-ID-Hash: QJ6376A2ULSLG3SS64DYLGRIL53BJ3GK
X-MailFrom: joao.m.martins@oracle.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/QJ6376A2ULSLG3SS64DYLGRIL53BJ3GK/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/16/20 5:00 PM, Dan Williams wrote:
> On Thu, Jul 16, 2020 at 6:19 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>> On 7/12/20 5:28 PM, Dan Williams wrote:
>>> In support of interrogating the physical address layout of a device with
>>> dis-contiguous ranges, introduce a sysfs directory with 'start', 'end',
>>> and 'page_offset' attributes. The alternative is trying to parse
>>> /proc/iomem, and that file will not reflect the extent layout until the
>>> device is enabled.
>>>
>>> Cc: Vishal Verma <vishal.l.verma@intel.com>
>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>> ---
>>>  drivers/dax/bus.c         |  191 +++++++++++++++++++++++++++++++++++++++++++++
>>>  drivers/dax/dax-private.h |   14 +++
>>>  2 files changed, 203 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>>> index f342e36c69a1..8b6c4ddc5f42 100644
>>> --- a/drivers/dax/bus.c
>>> +++ b/drivers/dax/bus.c
>>> @@ -579,6 +579,167 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>>>  }
>>>  EXPORT_SYMBOL_GPL(alloc_dax_region);
>>>
>>> +static void dax_mapping_release(struct device *dev)
>>> +{
>>> +     struct dax_mapping *mapping = to_dax_mapping(dev);
>>> +     struct dev_dax *dev_dax = to_dev_dax(dev->parent);
>>> +
>>> +     ida_free(&dev_dax->ida, mapping->id);
>>> +     kfree(mapping);
>>> +}
>>> +
>>> +static void unregister_dax_mapping(void *data)
>>> +{
>>> +     struct device *dev = data;
>>> +     struct dax_mapping *mapping = to_dax_mapping(dev);
>>> +     struct dev_dax *dev_dax = to_dev_dax(dev->parent);
>>> +     struct dax_region *dax_region = dev_dax->region;
>>> +
>>> +     dev_dbg(dev, "%s\n", __func__);
>>> +
>>> +     device_lock_assert(dax_region->dev);
>>> +
>>> +     dev_dax->ranges[mapping->range_id].mapping = NULL;
>>> +     mapping->range_id = -1;
>>> +
>>> +     device_del(dev);
>>> +     put_device(dev);
>>> +}
>>> +
>>> +static struct dev_dax_range *get_dax_range(struct device *dev)
>>> +{
>>> +     struct dax_mapping *mapping = to_dax_mapping(dev);
>>> +     struct dev_dax *dev_dax = to_dev_dax(dev->parent);
>>> +     struct dax_region *dax_region = dev_dax->region;
>>> +
>>> +     device_lock(dax_region->dev);
>>> +     if (mapping->range_id < 1) {
>>             ^^^^^^^^^^^^^^^^^^^^^ it's 'mapping->range_id < 0'
>>
>> Otherwise 'mapping0' sysfs entries won't work.
>> Disabled ranges use id -1.
> 
> Whoops, yes. Needs a unit test.
> 
If it helps, this particular patch for daxctl:

https://lore.kernel.org/linux-nvdimm/20200716184707.23018-7-joao.m.martins@oracle.com/

May help in the immediate term: if it's broken no mappings are listed.

But yeah, a unit test in 'test/daxctl-create.sh' should be added.

	Joao
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
