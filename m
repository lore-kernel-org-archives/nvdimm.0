Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B7B7212BF9B3
 for <linux-nvdimm@lists.01.org>; Fri, 19 Jul 2019 11:10:46 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v6 05/13] daxctl/list: add target_node for device
 listings
Date: Fri, 19 Jul 2019 18:08:18 +0000
Message-ID: <b86f69b2b0e7b3f3755c64f7a4310161dc8389dc.camel@intel.com>
References: <20190717225400.9494-1-vishal.l.verma@intel.com>
 <20190717225400.9494-6-vishal.l.verma@intel.com>
 <CAPcyv4jeVMQP8QAtiQt81n1+jS7J49L8Ki_GDtT6rXFmaxMogQ@mail.gmail.com>
In-Reply-To: <CAPcyv4jeVMQP8QAtiQt81n1+jS7J49L8Ki_GDtT6rXFmaxMogQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <8DF20C0B9CA2904DB3B0C56C720F7C6E@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2019-07-18 at 16:41 -0700, Dan Williams wrote:
> On Wed, Jul 17, 2019 at 3:54 PM Vishal Verma <vishal.l.verma@intel.com
> > wrote:
> > 
> > @@ -284,6 +285,13 @@ struct json_object
> > *util_daxctl_dev_to_json(struct daxctl_dev *dev,
> >         if (jobj)
> >                 json_object_object_add(jdev, "size", jobj);
> > 
> > +       node = daxctl_dev_get_target_node(dev);
> > +       if (node >= 0) {
> > +               jobj = json_object_new_int(node);
> > +               if (jobj)
> > +                       json_object_object_add(jdev, "target_node",
> > jobj);
> > +       }
> > +
> 
> We moved 'numa_node' to the UTIL_JSON_VERBOSE set on "ndctl list"
> should do the same for target node?

Hm, true. Arguably, the target_node is much more pertinent in system-ram 
mode, and /should/ be in the default verbosity?

One option could be to make it always show if the mode is system-ram,
but not otherwise - but I don't know if that would cause more confusion
as an attribute might seem to magically appear or disappear with the
same command options..

Yet another option is, the output right after daxctl-reconfigure-device
always sets UTIL_JSON_VERBOSE, but for daxctl-list, it is only done if
the user supplies it.

Any preferences on which way to go?

Thanks,
-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
