Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 60CEB211D35DC
 for <linux-nvdimm@lists.01.org>; Tue,  5 Jun 2018 11:15:01 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id b130-v6so2947009oif.12
 for <linux-nvdimm@lists.01.org>; Tue, 05 Jun 2018 11:15:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180605164205.GA21034@linux.intel.com>
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
 <20180521163203.26590-4-ross.zwisler@linux.intel.com>
 <20180605182243-mutt-send-email-mst@kernel.org>
 <20180605164205.GA21034@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Jun 2018 11:15:00 -0700
Message-ID: <CAPcyv4jSoFifTc05WGgxkEX6i7b12zYyB+VchJVW_+QPQzO7Fg@mail.gmail.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S. Tsirkin" <mst@redhat.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 5, 2018 at 9:42 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Tue, Jun 05, 2018 at 06:25:27PM +0300, Michael S. Tsirkin wrote:
>> On Mon, May 21, 2018 at 10:32:02AM -0600, Ross Zwisler wrote:
>> > Add a machine command line option to allow the user to control the Platform
>> > Capabilities Structure in the virtualized NFIT.  This Platform Capabilities
>> > Structure was added in ACPI 6.2 Errata A.
>> >
>> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>>
>> I tried playing with it and encoding the capabilities is
>> quite awkward.
>>
>> Can we add bits for specific capabilities instead of nvdimm-cap?
>>
>> How about:
>>
>> "cpu-flush-on-power-loss-cap"
>> "memory-flush-on-power-loss-cap"
>> "byte-addressable-mirroring-cap"
>
> Hmmm...I don't like that as much because:
>
> a) It's very verbose.  Looking at my current qemu command line few other
>    options require that many characters, and you'd commonly be defining more
>    than one of these for a given VM.
>
> b) It means that the QEMU will need to be updated if/when new flags are added,
>    because we'll have to have new options for each flag.  The current
>    implementation is more future-proof because you can specify any flags
>    value you want.
>
> However, if you feel strongly about this, I'll make the change.

Straw-man: Could we do something similar with what we are doing in ndctl?

enum ndctl_persistence_domain {
        PERSISTENCE_NONE = 0,
        PERSISTENCE_MEM_CTRL = 10,
        PERSISTENCE_CPU_CACHE = 20,
        PERSISTENCE_UNKNOWN = INT_MAX,
};

...and have the command line take a number where "10" and "20" are
supported today, but allows us to adapt to new persistence domains in
the future.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
