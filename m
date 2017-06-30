Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8159321BADAB1
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 12:52:37 -0700 (PDT)
Date: Fri, 30 Jun 2017 13:52:36 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, test: unit test updates for the BTT 2.0
 format
Message-ID: <20170630195236.GA27581@omniknight.lm.intel.com>
References: <20170624021758.26815-1-vishal.l.verma@intel.com>
 <CAPcyv4j9vFT7SWuWTAkC4QRJ_+LikNoX=rKqbqgbMvZPEwrTjw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j9vFT7SWuWTAkC4QRJ_+LikNoX=rKqbqgbMvZPEwrTjw@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 06/29, Dan Williams wrote:
> On Fri, Jun 23, 2017 at 7:17 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> > With the BTT 2.0 update, a couple of minor updates to the unit tests are
> > needed:
> > test/libndctl: Update expected BTT sizes
> > test/libndctl: in btt_autodetect, when wiping an old BTT, wipe the first
> > two 4K pages instead of one.
> >
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  test/libndctl.c | 19 +++++++++++++------
> >  1 file changed, 13 insertions(+), 6 deletions(-)
> >
> > diff --git a/test/libndctl.c b/test/libndctl.c
> > index 24aff36..89c4c02 100644
> > --- a/test/libndctl.c
> > +++ b/test/libndctl.c
> > @@ -994,16 +994,16 @@ static int check_btt_size(struct ndctl_btt *btt)
> >         int size_select, sect_select;
> >         unsigned long long expect_table[][2] = {
> >                 [0] = {
> > -                       [0] = 0x11b4400,
> > -                       [1] = 0x8da2000,
> > +                       [0] = 0x11b5400,
> > +                       [1] = 0x8daa000,
> >                 },
> >                 [1] = {
> > -                       [0] = 0x13b0400,
> > -                       [1] = 0x9d82000,
> > +                       [0] = 0x13b1400,
> > +                       [1] = 0x9d8a000,
> >                 },
> >                 [2] = {
> > -                       [0] = 0x1aa2600,
> > -                       [1] = 0xd513000,
> > +                       [0] = 0x1aa3600,
> > +                       [1] = 0xd51b000,
> 
> I think we need to have different expectations for different BTT
> versions. We should be able to check for v1.2 labels before picking
> the expectation, or just have a new ndctl_test_attempt() gate on the
> 4.13 kernel for the new sizes.

I'll make the call under a ndctl_test_atttempt. All of nfit_test will
switch to 1.2 labels with the next release, so keeping support for 1.1
sizes seems pointless..

> 
> >                 },
> >         };
> >
> > @@ -1517,12 +1517,19 @@ static int check_btt_autodetect(struct ndctl_bus *bus,
> >         }
> >
> >         memset(buf, 0, 4096);
> > +       /* Delete both the first and second 4K pages */
> >         rc = pwrite(fd, buf, 4096, 4096);
> >         if (rc < 4096) {
> >                 rc = -ENXIO;
> >                 fprintf(stderr, "%s: failed to overwrite btt on %s\n",
> >                                 devname, bdev);
> >         }
> > +       rc = pwrite(fd, buf, 4096, 0);
> > +       if (rc < 4096) {
> > +               rc = -ENXIO;
> > +               fprintf(stderr, "%s: failed to overwrite btt on %s\n",
> > +                               devname, bdev);
> > +       }
> 
> How about just change the first one to: "rc = pwrite(fd, buf, 8192, 0);"?

The buf that is passed in is only 4096 bytes, so I just took the easy
way out and did it twice :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
