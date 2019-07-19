Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 935352194EB78
 for <linux-nvdimm@lists.01.org>; Fri, 19 Jul 2019 11:39:17 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id w196so3661957oie.7
 for <linux-nvdimm@lists.01.org>; Fri, 19 Jul 2019 11:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190717225400.9494-1-vishal.l.verma@intel.com>
 <20190717225400.9494-6-vishal.l.verma@intel.com>
 <CAPcyv4jeVMQP8QAtiQt81n1+jS7J49L8Ki_GDtT6rXFmaxMogQ@mail.gmail.com>
 <b86f69b2b0e7b3f3755c64f7a4310161dc8389dc.camel@intel.com>
In-Reply-To: <b86f69b2b0e7b3f3755c64f7a4310161dc8389dc.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 19 Jul 2019 11:36:37 -0700
Message-ID: <CAPcyv4jimtN+70iJD1EeZVkuX7udUEnfCM-stEiXvsWtknaTPg@mail.gmail.com>
Subject: Re: [ndctl PATCH v6 05/13] daxctl/list: add target_node for device
 listings
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 19, 2019 at 11:08 AM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Thu, 2019-07-18 at 16:41 -0700, Dan Williams wrote:
> > On Wed, Jul 17, 2019 at 3:54 PM Vishal Verma <vishal.l.verma@intel.com
> > > wrote:
> > >
> > > @@ -284,6 +285,13 @@ struct json_object
> > > *util_daxctl_dev_to_json(struct daxctl_dev *dev,
> > >         if (jobj)
> > >                 json_object_object_add(jdev, "size", jobj);
> > >
> > > +       node = daxctl_dev_get_target_node(dev);
> > > +       if (node >= 0) {
> > > +               jobj = json_object_new_int(node);
> > > +               if (jobj)
> > > +                       json_object_object_add(jdev, "target_node",
> > > jobj);
> > > +       }
> > > +
> >
> > We moved 'numa_node' to the UTIL_JSON_VERBOSE set on "ndctl list"
> > should do the same for target node?
>
> Hm, true. Arguably, the target_node is much more pertinent in system-ram
> mode, and /should/ be in the default verbosity?
>
> One option could be to make it always show if the mode is system-ram,
> but not otherwise - but I don't know if that would cause more confusion
> as an attribute might seem to magically appear or disappear with the
> same command options..
>
> Yet another option is, the output right after daxctl-reconfigure-device
> always sets UTIL_JSON_VERBOSE, but for daxctl-list, it is only done if
> the user supplies it.
>
> Any preferences on which way to go?

'verbose after reconfigure' sounds good, but you're right, it's more
pertinent in the device-dax case, especially when that might be one of
our only identification mechanisms for non-NFIT device-dax. So I'm ok
to keep it as is on second thought.
>
> Thanks,
> -Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
