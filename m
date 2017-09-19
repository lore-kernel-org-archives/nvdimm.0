Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1EB5520945B78
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 16:42:34 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id t21so310897oih.6
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 16:45:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <11e8c954-7d54-ae4f-f4fe-459da79c2990@oracle.com>
References: <11e8c954-7d54-ae4f-f4fe-459da79c2990@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Sep 2017 16:45:38 -0700
Message-ID: <CAPcyv4ieKRPP43-FQQS5OfXigSZYoa5mEqiRN9ujj=fe37+e4g@mail.gmail.com>
Subject: Re: DAX error inject/page poison
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
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 19, 2017 at 4:15 PM, Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> We were trying to simulate pmem errors in an environment where a DAX
> filesystem is used (ext4 although I suspect it does not matter).  The
> sequence attempted on a DAX filesystem is:
> - Populate a file in the DAX filesystem
> - mmap the file
> - madvise(MADV_HWPOISON)
>
> The madvise operation fails with EFAULT.  This appears to come from
> get_user_pages() as there are no struct pages for such mappings?
>
> The idea is to make sure an application can recover from such errors
> by hole punching and repopulating with another page.
>
> A couple questions:
> It seems like madvise(MADV_HWPOISON) is not going to work (ever?) in
> such situations.  If so, should we perhaps add a IS_DAX like check and
> return something like EINVAL?  Or, at least document expected behavior?

The MADV_HWPOISON machinery assumes normal memory pages, not DAX and
certainly not the special ZONE_DEVICE pages we allocate for the
purpose of DMA. Returning EINVAL seems like the right thing to do
since there is no facility in the kernel to soft offline a DAX page.
In other words MADV_HWPOISON is for emulating errors in volatile
memory that might be transient until the next reboot, DAX errors cause
permanent data loss in filesytem files, so the error injection and
handling models need to be different.

> If madvise(MADV_HWPOISON) will not work, how can one inject errors to
> test error handling code?

Similar to "hdparm --make-bad-sector" we need a platform specific
facility to inject a hard memory error at a given physical persistent
memory address. In the case of an ACPI 6.2 based platform that
mechanism is: "Section 9.20.7.9 Function Index 7 - ARS Error Inject".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
