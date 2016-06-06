Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8184D1A1ED5
 for <linux-nvdimm@lists.01.org>; Mon,  6 Jun 2016 13:36:45 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id p204so49573269oih.3
 for <linux-nvdimm@lists.01.org>; Mon, 06 Jun 2016 13:36:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <25251cc2-b34a-504e-394f-b2062d1542ce@hpe.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146507355828.8347.11600179233094511139.stgit@dwillia2-desk3.amr.corp.intel.com>
 <0d64fc79-fdfa-9d50-c8b8-fc7c3e79f1f4@hpe.com>
 <CAPcyv4j2saB7=k=uw3Ze-cmsHW-PkHY=Xez4AomAxWUFR1-x2Q@mail.gmail.com>
 <2860536d-ce69-1d2e-4ca5-ca2f10b9695e@hpe.com>
 <CAPcyv4jvpfUHzdeNc+yVi-iS-e2kOx+7Tpoqx7xBfN12=rg6-A@mail.gmail.com>
 <25251cc2-b34a-504e-394f-b2062d1542ce@hpe.com>
Date: Mon, 6 Jun 2016 13:36:25 -0700
Message-ID: <CAPcyv4h5qejPHGZri6SDDAV9pON6-DFn1bgPeD6fjTRKXkF26A@mail.gmail.com>
Subject: Re: [PATCH 01/13] driver core, libnvdimm: disable manual unbind of
 dimms while region active
From: Dan Williams <dan.j.williams@intel.com>
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 6, 2016 at 1:20 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
[..]
>> A solution to the posted-write-queue flushing needs to be available
>> and a platform can choose to use flush hints or ADR.  If the NFIT
>> defines an NVDIMM device without hints we assume the platform must
>> have ADR.  If the platform NFIT neglects to define an NVDIMM to
>> physical address range mapping, we warn about a potentially broken
>> BIOS.  Hopefully we can make this clearer in future versions of the
>> spec.
>
> You lost me on those last 2 sentences.  An NVDIMM doesn't have to have
> an SPA range, but that seems to be unrelated to pcommit or flushes.

Ok, now you've lost me...

We need a SPA range to be able to do I/O whether that SPA range is
direct access to media or a block-window aperture.  If an NFIT
inculdes a "System Physical Address (SPA) Range Structure", but
neglects to include a corresponding "NVDIMM Region Mapping Structure"
then the kernel has no idea what actual dimm device(s) back that
memory region.  Without a memory device mapping it is undefined
whether I/O to a SPA range requires flushing or not.

This patch set silences the warning about "not being able to guarantee
persistence" when the BIOS provides a "NVDIMM Region Mapping
Structure".  When that structure is present the kernel uses flush
hints when provided, but ADR otherwise.  See the implementation of
nvdimm_flush() in patch 4.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
