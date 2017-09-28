Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDA6721F2AF69
 for <linux-nvdimm@lists.01.org>; Thu, 28 Sep 2017 09:25:04 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id p126so3157364oih.9
 for <linux-nvdimm@lists.01.org>; Thu, 28 Sep 2017 09:28:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49tvzmaiyy.fsf@segfault.boston.devel.redhat.com>
References: <150655617774.700.5326522538400299973.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150655618343.700.16350109614227108839.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49tvzmaiyy.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Sep 2017 09:28:18 -0700
Message-ID: <CAPcyv4hE-VnScR39cgsM4TROJdcMYqQkJVSHPMN6tvveGt-Pgg@mail.gmail.com>
Subject: Re: [PATCH 1/3] dax: disable filesystem dax on devices that do not
 map pages
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@lst.de>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 28, 2017 at 9:25 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> If a dax buffer from a device that does not map pages is passed to
>> read(2) or write(2) as a target for direct-I/O it triggers SIGBUS. If
>> gdb attempts to examine the contents of a dax buffer from a device that
>> does not map pages it triggers SIGBUS. If fork(2) is called on a process
>> with a dax mapping from a device that does not map pages it triggers
>> SIGBUS. 'struct page' is required otherwise several kernel code paths
>> break in surprising ways. Disable filesystem-dax on devices that do not
>> map pages.
>>
> [...]
>> @@ -123,6 +124,12 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
>>               return len < 0 ? len : -EIO;
>>       }
>>
>> +     if (!pfn_t_has_page(pfn)) {
>> +             pr_err("VFS (%s): error: dax support not enabled\n",
>> +                             sb->s_id);
>
> Is the pr_err really necessary?  At least one caller already prints a
> warning.  It seems cleaner to me to let the caller determine whether
> it's worth printing anything.

Agreed, I'll drop it in v2.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
