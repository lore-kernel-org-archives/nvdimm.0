Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9A9B202110D8
 for <linux-nvdimm@lists.01.org>; Mon, 26 Aug 2019 09:00:51 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: create devdax with "-a 1g" failed from 5.3.0-rc1
References: <1254901996.3735926.1564533684889.JavaMail.zimbra@redhat.com>
 <x498srsdhrs.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 26 Aug 2019 11:58:28 -0400
In-Reply-To: <x498srsdhrs.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
 message of "Fri, 16 Aug 2019 15:36:39 -0400")
Message-ID: <x49y2zfudej.fsf@segfault.boston.devel.redhat.com>
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
To: dan.j.williams@intel.com
Cc: Yi Zhang <yi.zhang@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan, we should probably fix this before 5.3 ships.  Do you have any
concerns with the patch I attached?  If not, I'll submit a proper one.

-Jeff

Jeff Moyer <jmoyer@redhat.com> writes:

> Hi, Yi,
>
> Yi Zhang <yi.zhang@redhat.com> writes:
>
>> Hi Dan
>>
>> As subject, I found it failed from bellow commit[1], steps list here
>> [2] and I've attached the full dmesg, let me know if you need more
>> info, thanks.
>>
>> [1]
>> commit a3619190d62ed9d66416891be2416f6bea2b3ca4 (refs/bisect/bad)
>> Author: Dan Williams <dan.j.williams@intel.com>
>> Date:   Thu Jul 18 15:58:40 2019 -0700
>>
>>     libnvdimm/pfn: stop padding pmem namespaces to section alignment
>>
>> [2]
>> # ./ndctl destroy-namespace all -r all -f
>> destroyed 5 namespaces
>> # ./ndctl create-namespace -r region1 -m devdax -a 1g -s 12G -vv
>> libndctl: ndctl_dax_enable: dax1.0: failed to enable
>>   Error: namespace1.0: failed to enable
>>
>> failed to create namespace: No such device or address
>> # ./ndctl -v
>> 65
>
> Thanks for bisecting.  The problem is that your pmem region is not
> aligned to 1GB.  The current code handles the start offset just fine,
> but does not even consider that the end address might be misaligned.  We
> could bring back end_trunc, and that solves the problem.  Unfortunately,
> it means that if you request a 12GB namespace, for example, you'll only
> get 11GB of usable space.  Note that the old code functioned in this
> manner, too.  A better solution would be to bump the allocation so that
> you get 12GB of usable memory.  I'm not quite sure how to go about that,
> though.  Dan?
>
> Below is a patch that fixes the regression on my end.  Feel free to give
> it a try.
>
> -Jeff
>
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 3e7b11c..cb98b8f 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -655,6 +655,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>  	resource_size_t start, size;
>  	struct nd_region *nd_region;
>  	unsigned long npfns, align;
> +	u32 end_trunc;
>  	struct nd_pfn_sb *pfn_sb;
>  	phys_addr_t offset;
>  	const char *sig;
> @@ -696,6 +697,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>  	size = resource_size(&nsio->res);
>  	npfns = PHYS_PFN(size - SZ_8K);
>  	align = max(nd_pfn->align, (1UL << SUBSECTION_SHIFT));
> +	end_trunc = start + size - ALIGN_DOWN(start + size, align);
>  	if (nd_pfn->mode == PFN_MODE_PMEM) {
>  		/*
>  		 * The altmap should be padded out to the block size used
> @@ -714,7 +716,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>  		return -ENXIO;
>  	}
>  
> -	npfns = PHYS_PFN(size - offset);
> +	npfns = PHYS_PFN(size - offset - end_trunc);
>  	pfn_sb->mode = cpu_to_le32(nd_pfn->mode);
>  	pfn_sb->dataoff = cpu_to_le64(offset);
>  	pfn_sb->npfns = cpu_to_le64(npfns);
> @@ -723,6 +725,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>  	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
>  	pfn_sb->version_major = cpu_to_le16(1);
>  	pfn_sb->version_minor = cpu_to_le16(3);
> +	pfn_sb->end_trunc = cpu_to_le32(end_trunc);
>  	pfn_sb->align = cpu_to_le32(nd_pfn->align);
>  	checksum = nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
>  	pfn_sb->checksum = cpu_to_le64(checksum);
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
