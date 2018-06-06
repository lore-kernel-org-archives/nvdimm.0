Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA13E2116524A
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 16:40:32 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id d19-v6so3808763oti.8
 for <linux-nvdimm@lists.01.org>; Wed, 06 Jun 2018 16:40:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB1169403448C8AA5FF267F6A6AB650@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
 <20180521163203.26590-4-ross.zwisler@linux.intel.com>
 <20180605182243-mutt-send-email-mst@kernel.org>
 <20180605164205.GA21034@linux.intel.com>
 <CAPcyv4jSoFifTc05WGgxkEX6i7b12zYyB+VchJVW_+QPQzO7Fg@mail.gmail.com>
 <20180605213547-mutt-send-email-mst@kernel.org>
 <20180605220700.GB16066@linux.intel.com>
 <CAPcyv4irudGth3+WZtgF4TjGL53s8mN70aVXpGWjj_Lc=7AMVg@mail.gmail.com>
 <AT5PR8401MB1169403448C8AA5FF267F6A6AB650@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Jun 2018 16:40:31 -0700
Message-ID: <CAPcyv4gwsasnnt=LpU5wgbjvL8=w+fErCPtNHyRDGO1iQukYnw@mail.gmail.com>
Subject: Re: [qemu PATCH v4 3/4] nvdimm,
 acpi: support NFIT platform capabilities
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 6, 2018 at 4:20 PM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>> > Okay, we can move to the symbolic names.  Do you want them to be that
>> long, or
>> > would:
>> >
>> > nvdimm-cap-cpu
>> > nvdimm-cap-mem-ctrl
>> > nvdimm-cap-mirroring
>>
>> Wait, why is mirroring part of this?
>
> This data structure is intended to report any kind of platform capability, not
> just platform persistence capabilities.

Yes, but here's nothing actionable that a qemu guest OS can do with
that mirroring information, so there's no need at this time to add cli
cruft and code to support it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
