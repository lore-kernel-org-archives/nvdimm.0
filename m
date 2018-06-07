Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BDF621103DDE
 for <linux-nvdimm@lists.01.org>; Thu,  7 Jun 2018 08:29:45 -0700 (PDT)
Date: Thu, 7 Jun 2018 18:29:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [qemu PATCH v4 3/4] nvdimm, acpi: support NFIT platform
 capabilities
Message-ID: <20180607182900-mutt-send-email-mst@kernel.org>
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
 <20180521163203.26590-4-ross.zwisler@linux.intel.com>
 <20180605182243-mutt-send-email-mst@kernel.org>
 <20180605164205.GA21034@linux.intel.com>
 <CAPcyv4jSoFifTc05WGgxkEX6i7b12zYyB+VchJVW_+QPQzO7Fg@mail.gmail.com>
 <20180605213547-mutt-send-email-mst@kernel.org>
 <20180605220700.GB16066@linux.intel.com>
 <CAPcyv4irudGth3+WZtgF4TjGL53s8mN70aVXpGWjj_Lc=7AMVg@mail.gmail.com>
 <AT5PR8401MB1169403448C8AA5FF267F6A6AB650@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4gwsasnnt=LpU5wgbjvL8=w+fErCPtNHyRDGO1iQukYnw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gwsasnnt=LpU5wgbjvL8=w+fErCPtNHyRDGO1iQukYnw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 06, 2018 at 04:40:31PM -0700, Dan Williams wrote:
> On Wed, Jun 6, 2018 at 4:20 PM, Elliott, Robert (Persistent Memory)
> <elliott@hpe.com> wrote:
> >
> >> > Okay, we can move to the symbolic names.  Do you want them to be that
> >> long, or
> >> > would:
> >> >
> >> > nvdimm-cap-cpu
> >> > nvdimm-cap-mem-ctrl
> >> > nvdimm-cap-mirroring
> >>
> >> Wait, why is mirroring part of this?
> >
> > This data structure is intended to report any kind of platform capability, not
> > just platform persistence capabilities.
> 
> Yes, but here's nothing actionable that a qemu guest OS can do with
> that mirroring information, so there's no need at this time to add cli
> cruft and code to support it.

I agree.

-- 
MST
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
