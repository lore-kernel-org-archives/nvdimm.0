Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 555F71A1F01
 for <linux-nvdimm@lists.01.org>; Thu, 15 Sep 2016 10:01:05 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id w11so78684551oia.2
 for <linux-nvdimm@lists.01.org>; Thu, 15 Sep 2016 10:01:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160915082615.GA9772@lst.de>
References: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160915082615.GA9772@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Sep 2016 10:01:03 -0700
Message-ID: <CAPcyv4jTw3cXpmmJRh7t16Xy2uYofDe+fJ+X_jnz+Q=o0uGneg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm, dax: add VM_DAX flag for DAX VMAs
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Nicholas Piggin <npiggin@gmail.com>, XFS Developers <xfs@oss.sgi.com>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 15, 2016 at 1:26 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Sep 14, 2016 at 11:54:38PM -0700, Dan Williams wrote:
>> The DAX property, page cache bypass, of a VMA is only detectable via the
>> vma_is_dax() helper to check the S_DAX inode flag.  However, this is
>> only available internal to the kernel and is a property that userspace
>> applications would like to interrogate.
>
> They have absolutely no business knowing such an implementation detail.

Hasn't that train already left the station with FS_XFLAG_DAX?

The other problem with hiding the DAX property is that it turns out to
not be a transparent acceleration feature.  See xfs/086 xfs/088
xfs/089 xfs/091 which fail with DAX and, as far as I understand, it is
due to the fact that DAX disallows delayed allocation behavior.

If behavior changes I think we should indicate that to userspace and
VM_DAX is certainly more useful to userspace than some of the other vm
internals we already export in those flags.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
