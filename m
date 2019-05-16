Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 86D6921250464
 for <linux-nvdimm@lists.01.org>; Thu, 16 May 2019 14:51:53 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id c3so4911585otr.3
 for <linux-nvdimm@lists.01.org>; Thu, 16 May 2019 14:51:53 -0700 (PDT)
MIME-Version: 1.0
References: <155727335978.292046.12068191395005445711.stgit@dwillia2-desk3.amr.corp.intel.com>
 <059859ca-3cc8-e3ff-f797-1b386931c41e@deltatee.com>
 <17ada515-f488-d153-90ef-7a5cc5fefb0f@deltatee.com>
 <8a7cfa6b-6312-e8e5-9314-954496d2f6ce@oracle.com>
 <CAPcyv4i28tQMVrscQo31cfu1ZcMAb74iMkKYhu9iO_BjJvp+9A@mail.gmail.com>
 <6bd8319d-3b73-bb1e-5f41-94c580ba271b@oracle.com>
 <d699e312-0e88-30c7-8e50-ff624418d486@oracle.com>
In-Reply-To: <d699e312-0e88-30c7-8e50-ff624418d486@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 May 2019 14:51:40 -0700
Message-ID: <CAPcyv4hujnGHtTwE78gvmEoY3Y6nLsd1AhJfeKMwHrxLvStf9w@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] mm/devm_memremap_pages: Fix page release race
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
To: Jane Chu <jane.chu@oracle.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 16, 2019 at 9:45 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> Hi,
>
> I'm able to reproduce the panic below by running two sets of ndctl
> commands that actually serve legitimate purpose in parallel (unlike
> the brute force experiment earlier), each set in a indefinite loop.
> This time it takes about an hour to panic.  But I gather the cause
> is probably the same: I've overlapped ndctl commands on the same
> region.
>
> Could we add a check in nd_ioctl(), such that if there is
> an ongoing ndctl command on a region, subsequent ndctl request
> will fail immediately with something to the effect of EAGAIN?
> The rationale being that kernel should protect itself against
> user mistakes.

We do already have locking in the driver to prevent configuration
collisions. The problem looks to be broken assumptions about running
the device unregistration path in a separate thread outside the lock.
I suspect it may be incorrect assumptions about the userspace
visibility of the device relative to teardown actions. To be clear
this isn't the nd_ioctl() path this is the sysfs path.


> Also, sensing the subject fix is for a different problem, and has been
> verified, I'm happy to see it in upstream, so we have a better
> code base to digger deeper in terms of how the destructive ndctl
> commands interacts to typical mission critical applications, include
> but not limited to rdma.

Right, the crash signature you are seeing looks unrelated to the issue
being address in these patches which is device-teardown racing active
page pins. I'll start the investigation on the crash signature, but
again I don't think it reads on this fix series.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
