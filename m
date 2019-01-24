Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BBDB211B1112
 for <linux-nvdimm@lists.01.org>; Wed, 23 Jan 2019 17:07:51 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v9 02/13] ndctl: add command for ndctl to receive the
 key encryption key (master)
Date: Thu, 24 Jan 2019 01:07:50 +0000
Message-ID: <4704317c462678f4451fc4902a0f7bdc78c4ddf6.camel@intel.com>
References: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
 <154777911312.42557.15688834797714631330.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hgA+uht-BeDdeom-sw3q2ihnXsx8p6csk41fRPeDXwRQ@mail.gmail.com>
In-Reply-To: <CAPcyv4hgA+uht-BeDdeom-sw3q2ihnXsx8p6csk41fRPeDXwRQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <9337CA39DE03224B8462A26C543C159C@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-01-23 at 09:45 -0800, Dan Williams wrote:
> > 

[..]

> On Thu, Jan 17, 2019 at 6:38 PM Dave Jiang <dave.jiang@intel.com> wrote:
> > +static int store_kek(const char *provider, const char *kek)
> > +{
> > +       char path[PATH_MAX];
> > +       FILE *fp;
> > +       ssize_t rc, wrote = 0;
> > +       int size = strlen(kek);
> > +
> > +       rc = sprintf(path, "%s/%s.kek", NDCTL_KEYS_DIR, provider);
> > +       if (rc < 0) {
> > +               perror("sprintf kek path failed");
> > +               return rc;
> > +       }
> > +
> > +       fp = fopen(path, "w+");
> > +       if (!fp) {
> > +               fprintf(stderr, "Opening file %s failed: %s\n",
> > +                               path, strerror(errno));
> > +               return -errno;
> > +       }
> > +
> > +       do {
> > +               rc = fwrite(kek + wrote, 1, size - wrote, fp);
> > +               if (rc < 0) {
> > +                       fprintf(stderr, "writing file %s failed: %s\n",
> > +                                       path, strerror(errno));
> > +                       fclose(fp);
> > +                       return -errno;
> > +               }
> > +               wrote += rc;
> > +       } while (wrote != size);
> > +
> > +       fclose(fp);
> > +       printf("key handle %s installed to %s\n", kek, path);
> > +       return 0;
> 
> So the format of this file is just name it by the bus provider and
> store the flat key name inside? That would seem to make supporting a
> key per-dimm more complicated in the future.
> 
> It would be nice to steal the git config file handling since it could
> do something like this:
> 
> [ key "<description>" ]
>     bus = <provider>
>     dimm = <dimm unique-id>
>     file = <path to key data>
> 
> Where multiple keys can be recorded by unique descriptions and the
> properties can be used as a match spec to scope that key to a set of
> DIMMs. For example a system-wide master key
> 
> [ key "system-master" ]
>     bus = all
>     file = key.blob
> 
> ...and the following would identify a kek for a single dimm.
> 
> [ key "dimm0" ]
>     dimm = "8680-57341200"
>     file = key.blob
> 
> ...the roadblock of course being how easy (or not easy) it is to steal
> the config file capabilities from git.
> 
> Too complicated? Other ideas?

I like the general scheme..

But it sounds like a pre-requisite for this might be the config rework
that we will have for ndctl-monitor in the future. I'm trying to think
of how this will tie in with that - ideally we have one global config
file, and that includes sections for different commands. Ideally keys
also get described there.. Maybe each [key "foo"] section can be such a
top level section?

The other option is a security specific config file, but if we're
unifying the config file handling, I think this should be part of it
from the start.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
