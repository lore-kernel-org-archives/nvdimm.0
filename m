Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63B6921159C93
 for <linux-nvdimm@lists.01.org>; Tue,  5 Jun 2018 09:42:07 -0700 (PDT)
Date: Tue, 5 Jun 2018 10:42:05 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [qemu PATCH v4 3/4] nvdimm, acpi: support NFIT platform
 capabilities
Message-ID: <20180605164205.GA21034@linux.intel.com>
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
 <20180521163203.26590-4-ross.zwisler@linux.intel.com>
 <20180605182243-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180605182243-mutt-send-email-mst@kernel.org>
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 05, 2018 at 06:25:27PM +0300, Michael S. Tsirkin wrote:
> On Mon, May 21, 2018 at 10:32:02AM -0600, Ross Zwisler wrote:
> > Add a machine command line option to allow the user to control the Platform
> > Capabilities Structure in the virtualized NFIT.  This Platform Capabilities
> > Structure was added in ACPI 6.2 Errata A.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> I tried playing with it and encoding the capabilities is
> quite awkward.
> 
> Can we add bits for specific capabilities instead of nvdimm-cap?
> 
> How about:
> 
> "cpu-flush-on-power-loss-cap"
> "memory-flush-on-power-loss-cap"
> "byte-addressable-mirroring-cap"

Hmmm...I don't like that as much because:

a) It's very verbose.  Looking at my current qemu command line few other
   options require that many characters, and you'd commonly be defining more
   than one of these for a given VM.

b) It means that the QEMU will need to be updated if/when new flags are added,
   because we'll have to have new options for each flag.  The current
   implementation is more future-proof because you can specify any flags
   value you want.

However, if you feel strongly about this, I'll make the change.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
