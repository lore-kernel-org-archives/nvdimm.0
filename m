Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EF99C2214672B
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 10:33:48 -0700 (PDT)
Date: Wed, 21 Mar 2018 11:39:38 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v5] ndctl: Add support for get bus and region persistence
 domain
Message-ID: <20180321173938.GB16113@linux.intel.com>
References: <152158617536.58088.15400091856423589188.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4h+dSMP4hHxx+VspD5aJE3HzhSGt-gGpUQMS3P6wJiP6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4h+dSMP4hHxx+VspD5aJE3HzhSGt-gGpUQMS3P6wJiP6Q@mail.gmail.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 20, 2018 at 08:41:25PM -0700, Dan Williams wrote:
> On Tue, Mar 20, 2018 at 3:50 PM, Dave Jiang <dave.jiang@intel.com> wrote:
<>
> > +static int region_persistence_scan(struct ndctl_region *region)
> > +{
> > +       struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
> > +       char *pd_path;
> > +       FILE *pf;
> > +       char buf[64];
> > +       int rc = 0;
> > +       enum ndctl_persistence_domain pd = PERSISTENCE_NONE;
> > +
> > +       region->persistence_domain = PERSISTENCE_NONE;
> > +       if (asprintf(&pd_path, "%s/persistence_domain",
> > +                               region->region_path) < 0) {
> > +               rc = -errno;
> > +               err(ctx, "region persist domain path allocation failure\n");
> > +               return rc;
> > +       }
> > +
> > +       pf = fopen(pd_path, "re");
> > +       if (!pf) {
> > +               rc = -errno;
> > +               free(pd_path);
> > +               return rc;
> > +       }
> > +
> > +       do {
> > +               rc = fscanf(pf, "%s", buf);
> > +               if (rc == EOF) {
> > +                       if (ferror(pf)) {
> > +                               rc = -errno;
> > +                               goto out;
> > +                       }
> > +               } else if (rc == 1)
> > +                       pd = region_get_pd_type(buf);
> > +
> > +               if (region->persistence_domain < pd)
> > +                       region->persistence_domain = pd;
> > +       } while (rc != EOF);
> 
> I would expect sysfs_read_attr() here? I don't otherwise see a reason
> to have special case code for this attribute.

And when using sysfs_read_attr() we need to be sure to have a buffer size of
SYSFS_ATTR_SIZE instead of a hard coded 64.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
