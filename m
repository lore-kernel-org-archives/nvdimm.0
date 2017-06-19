Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x236.google.com (mail-ot0-x236.google.com
 [IPv6:2607:f8b0:4003:c0f::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A08B821C8F628
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 19:05:50 -0700 (PDT)
Received: by mail-ot0-x236.google.com with SMTP id y47so36718452oty.0
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 19:07:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170618084557.GD26456@lst.de>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703989611.20620.6907872165215640212.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170618084557.GD26456@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 18 Jun 2017 19:07:10 -0700
Message-ID: <CAPcyv4gk_0d-aykn2WQJSTArpR+fReWmtY_5=TLpW_uHPbNEeA@mail.gmail.com>
Subject: Re: [PATCH v3 13/14] filesystem-dax: gate calls to dax_flush() on
 QUEUE_FLAG_WC
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, dm-devel@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 18, 2017 at 1:45 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Jun 09, 2017 at 01:24:56PM -0700, Dan Williams wrote:
>> Some platforms arrange for cpu caches to be flushed on power-fail. On
>> those platforms there is no requirement that the kernel track and flush
>> potentially dirty cache lines. Given that we still insert entries into
>> the radix for locking purposes this patch only disables the cache flush
>> loop, not the dirty tracking.
>>
>> Userspace can override the default cache setting via the block device
>> queue "write_cache" attribute in sysfs.
>
> NAK.  Please stop using the block infrastructure for dax values.  Have
> your own flag and sysfs file in the dax infrastructure and only propagate
> it to the block layer for the block devices using dax.

Ok, that makes sense.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
