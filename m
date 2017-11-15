Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00BBA220D4C0C
 for <linux-nvdimm@lists.01.org>; Tue, 14 Nov 2017 17:43:44 -0800 (PST)
Received: by mail-oi0-x243.google.com with SMTP id y206so13794162oiy.4
 for <linux-nvdimm@lists.01.org>; Tue, 14 Nov 2017 17:47:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <x49y3n8s4o8.fsf@segfault.boston.devel.redhat.com>
References: <x49y3n8s4o8.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 14 Nov 2017 17:47:51 -0800
Message-ID: <CAPcyv4gnqfBs9MyZtW0hq9Ffv8N5XXfpDYGP8GzCHnDGXe-EVA@mail.gmail.com>
Subject: Re: [patch] dax: fix PMD faults on zero-length files
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Zwisler, Ross  <ross.zwisler@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 14, 2017 at 5:37 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> PMD faults on a zero length file on a file system mounted with -o dax
> will not generate SIGBUS as expected.
>
>         fd = open(...O_TRUNC);
>         addr = mmap(NULL, 2*1024*1024, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
>         *addr = 'a';
>         <expect SIGBUS>
>
> The problem is this code in dax_iomap_pmd_fault:
>
>         max_pgoff = (i_size_read(inode) - 1) >> PAGE_SHIFT;
>
> If the inode size is zero, we end up with a max_pgoff that is way larger
> than 0.  :)  Fix it by using DIV_ROUND_UP, as is done elsewhere in the
> kernel.
>
> I tested this with some simple test code that ensured that SIGBUS was
> received where expected.
>

I assume this needs:

   Fixes: 642261ac995e ("dax: add struct iomap based DAX PMD support")
   Cc: <stable@vger.kernel.org>

...otherwise looks good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
