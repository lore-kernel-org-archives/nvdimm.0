Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A8DFB210D851D
 for <linux-nvdimm@lists.01.org>; Wed, 20 Jun 2018 12:51:41 -0700 (PDT)
Date: Wed, 20 Jun 2018 13:51:39 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, test: Update tests for capacity vs
 namespace-label locking
Message-ID: <20180620195132.GA22544@vverma7-mobl4.lm.intel.com>
References: <152902249055.9927.9157713405568345680.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180618213530.GB4226@vverma7-mobl4.lm.intel.com>
 <CAPcyv4iusXi4_HjAayCU2HZsge_QL9oQaQk4K3aBbEP+XWAmeg@mail.gmail.com>
 <20180620045923.GA31546@vverma7-mobl4.lm.intel.com>
 <CAPcyv4jyV_XtV2+irxen2GxemN7Zj_A3kBbBNa7i2O19jmQCjw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jyV_XtV2+irxen2GxemN7Zj_A3kBbBNa7i2O19jmQCjw@mail.gmail.com>
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

On 06/19, Dan Williams wrote:
> On Tue, Jun 19, 2018 at 9:59 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> > On 06/18, Dan Williams wrote:
> >> On Mon, Jun 18, 2018 at 2:35 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> >> > On 06/14, Dan Williams wrote:
> >> >> Check that namespaces can be enumerated, but are disabled if the labels
> >> >> are readable while the DIMM is locked. Alternatively, if the namespace
> >> >> label area is locked, validate that regions with the affected DIMM fail
> >> >> to enable.
> >> >>
> >> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> >> ---
> >> >>  test/Makefile.am |   10 +-
> >> >>  test/dsm-fail.c  |  305 ++++++++++++++++++++++++++++++++++++++++++++----------
> >> >>  2 files changed, 257 insertions(+), 58 deletions(-)
> >> >>
> >> >> diff --git a/test/Makefile.am b/test/Makefile.am
> >> >> index 92cf29d6065e..f6483910af45 100644
> >> >> --- a/test/Makefile.am
> >> >> +++ b/test/Makefile.am
> >> >> @@ -69,9 +69,15 @@ libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
> >> >>
> >> >>  dsm_fail_SOURCES =\
> >> >>       dsm-fail.c \
> >> >> -     $(testcore)
> >> >> +     $(testcore) \
> >> >> +     ../ndctl/namespace.c \
> >> >> +     ../ndctl/check.c \
> >> >> +     ../util/json.c
> >> >>
> >> >> -dsm_fail_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
> >> >> +dsm_fail_LDADD = $(LIBNDCTL_LIB) \
> >> >> +             $(KMOD_LIBS) \
> >> >> +             $(JSON_LIBS) \
> >> >> +             ../libutil.a
> >> >>
> >> >>  ack_shutdown_count_set_SOURCES =\
> >> >>       ack-shutdown-count-set.c \
> >> >> diff --git a/test/dsm-fail.c b/test/dsm-fail.c
> >> >> index 90d3e074f12b..b0df9da8ffab 100644
> >> >> --- a/test/dsm-fail.c
> >> >> +++ b/test/dsm-fail.c
> >> >> @@ -24,6 +24,7 @@
> >> >>
> >> >>  #include <ccan/array_size/array_size.h>
> >> >>  #include <ndctl/libndctl.h>
> >> >> +#include <builtin.h>
> >> >>  #include <ndctl.h>
> >> >>  #include <test.h>
> >> >>
> >> >> @@ -38,20 +39,153 @@ static void reset_bus(struct ndctl_bus *bus)
> >> >>       ndctl_region_foreach(bus, region)
> >> >>               ndctl_region_disable_invalidate(region);
> >> >>
> >> >> -     ndctl_dimm_foreach(bus, dimm)
> >> >> -             ndctl_dimm_zero_labels(dimm);
> >> >> +     ndctl_dimm_foreach(bus, dimm) {
> >> >> +             struct ndctl_cmd *cmd_read = ndctl_dimm_read_labels(dimm);
> >> >
> >> > This results in an unused variable warning for cmd_read. Perhaps if we
> >> > just want tp perform the read but not do anything with the cmd struct,
> >> > we can call it without storing the return anywhere?
> >>
> >> Oh, whoops. If cmd_read is NULL we should fail the test. I'll spin a
> >> new version.
> >
> > How does this incremental patch look  for fixing the above:
> >
> > From edbb972166fb5807096e352ae29bb5187701d95f Mon Sep 17 00:00:00 2001
> > From: Vishal Verma <vishal.l.verma@intel.com>
> > Date: Tue, 19 Jun 2018 22:57:11 -0600
> > Subject: [ndctl PATCH] fixup! ndctl, test: Update tests for capacity vs
> >  namespace-label locking
> >
> > ---
> >  test/dsm-fail.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/test/dsm-fail.c b/test/dsm-fail.c
> > index b0df9da..45a6c4f 100644
> > --- a/test/dsm-fail.c
> > +++ b/test/dsm-fail.c
> > @@ -30,7 +30,7 @@
> >
> >  #define DIMM_PATH "/sys/devices/platform/nfit_test.0/nfit_test_dimm/test_dimm0"
> >
> > -static void reset_bus(struct ndctl_bus *bus)
> > +static int reset_bus(struct ndctl_bus *bus)
> >  {
> >         struct ndctl_region *region;
> >         struct ndctl_dimm *dimm;
> > @@ -40,8 +40,8 @@ static void reset_bus(struct ndctl_bus *bus)
> >                 ndctl_region_disable_invalidate(region);
> >
> >         ndctl_dimm_foreach(bus, dimm) {
> > -               struct ndctl_cmd *cmd_read = ndctl_dimm_read_labels(dimm);
> > -
> > +               if (!ndctl_dimm_read_labels(dimm))
> > +                       return -ENXIO;
> >                 ndctl_dimm_disable(dimm);
> >                 ndctl_dimm_init_labels(dimm, NDCTL_NS_VERSION_1_2);
> >                 ndctl_dimm_enable(dimm);
> > @@ -50,6 +50,7 @@ static void reset_bus(struct ndctl_bus *bus)
> >         /* set regions back to their default state */
> >         ndctl_region_foreach(bus, region)
> >                 ndctl_region_enable(region);
> > +       return 0;
> >  }
> >
> >  static int set_dimm_response(const char *dimm_path, int cmd, int error_code,
> > @@ -198,7 +199,10 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
> >
> >         log_init(&log_ctx, "test/dsm-fail", "NDCTL_TEST");
> >
> > -       reset_bus(bus);
> > +       if (reset_bus(bus)) {
> > +               fprintf(stderr, "failed to read labels\n");
> > +               return -ENXIO;
> > +       }
> >
> >         sprintf(path, "%s/handle", DIMM_PATH);
> >         rc = __sysfs_read_attr(&log_ctx, path, buf);
> 
> Looks good to me.

Thanks. I also added in the following because without it, building in
Ubuntu would cause an unreferenced symbol error.

8<----


>From 205860f23c7814feae1c7f6b7d1a21326cf744f4 Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 20 Jun 2018 13:16:40 -0600
Subject: [ndctl PATCH] fixup! ndctl, test: Update tests for capacity vs
 namespace-label locking

---
 test/Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/Makefile.am b/test/Makefile.am
index f648391..cd451e9 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -77,6 +77,7 @@ dsm_fail_SOURCES =\
 dsm_fail_LDADD = $(LIBNDCTL_LIB) \
 		$(KMOD_LIBS) \
 		$(JSON_LIBS) \
+		$(UUID_LIBS) \
 		../libutil.a
 
 ack_shutdown_count_set_SOURCES =\
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
