Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DFB01210F75D6
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 10:41:15 -0700 (PDT)
Date: Fri, 8 Jun 2018 11:41:14 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [Qemu-devel] [qemu PATCH 4/5] machine: fix some misspelled words
Message-ID: <20180608174114.GA30678@linux.intel.com>
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <20180607223111.27792-4-ross.zwisler@linux.intel.com>
 <17f8856c-48d9-d112-cd7f-e1b3679d2f43@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <17f8856c-48d9-d112-cd7f-e1b3679d2f43@redhat.com>
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
To: Thomas Huth <thuth@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S. Tsirkin" <mst@redhat.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 08, 2018 at 07:38:17AM +0200, Thomas Huth wrote:
> On 08.06.2018 00:31, Ross Zwisler wrote:
> > Normally this might not be worth fixing, but several of these are strings
> > which are displayed to users.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > ---
> >  hw/core/machine.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > index 617e5f8d75..a21269fa39 100644
> > --- a/hw/core/machine.c
> > +++ b/hw/core/machine.c
> > @@ -609,7 +609,7 @@ static void machine_class_init(ObjectClass *oc, void *data)
> >          machine_get_igd_gfx_passthru, machine_set_igd_gfx_passthru,
> >          &error_abort);
> >      object_class_property_set_description(oc, "igd-passthru",
> > -        "Set on/off to enable/disable igd passthrou", &error_abort);
> > +        "Set on/off to enable/disable igd passthru", &error_abort);
> 
> Shouldn't that rather be "passthrough" instead?

Either works, I think.  "thru" and "passthru" are short informal versions of
"through" and "passthrough", but both the long and short versions of both
words are used all over the QEMU source.  "passthrou" is clearly wrong.  If
the longer version is preferred in this case please feel free to fix up when
you apply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
