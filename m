Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 910921A22E7
 for <linux-nvdimm@lists.01.org>; Wed, 20 Apr 2016 09:50:34 -0700 (PDT)
Date: Wed, 20 Apr 2016 10:50:31 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [RFC v9 3/5] Subject: [PATCH v8 07/10] tools/testing/nvdimm:
 'call_dsm' support
Message-ID: <20160420165031.GB29474@tevye.fc.hp.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <e069fdba64643ab83458bfc2b88711dc1974e6a8.1460936121.git.jerry.hoemann@hpe.com>
 <CAPcyv4hC2f0Ekf6sk4Xg3Wyqwg9N6yj8NZ4y_coSSLOPE3E-2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hC2f0Ekf6sk4Xg3Wyqwg9N6yj8NZ4y_coSSLOPE3E-2Q@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 18, 2016 at 07:22:00PM -0700, Dan Williams wrote:
> On Sun, Apr 17, 2016 at 4:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > Enable nfit_test to use the generic 'call_dsm' envelope.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  tools/testing/nvdimm/test/nfit.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> > index 1d3b8ce..5afc3d3 100644
> > --- a/tools/testing/nvdimm/test/nfit.c
> > +++ b/tools/testing/nvdimm/test/nfit.c
> > @@ -336,12 +336,21 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
> >  {
> >         struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
> >         struct nfit_test *t = container_of(acpi_desc, typeof(*t), acpi_desc);
> > +       unsigned int func = cmd;
> >         int i, rc = 0, __cmd_rc;
> >
> >         if (!cmd_rc)
> >                 cmd_rc = &__cmd_rc;
> >         *cmd_rc = 0;
> >
> > +       if (cmd == ND_CMD_CALL) {
> > +               struct nd_cmd_pkg *call_dsm = buf;
> > +
> > +               buf_len = call_dsm->nd_size_in + call_dsm->nd_size_out;
> > +               buf = (void *) call_dsm->nd_payload;
> > +               func = call_dsm->nd_command;
> 
> Same comment as patch1, now that we've switched from call_dsm to
> nd_cmd_pkg, let's use 'pkg' as the local variable name.

  Fine.


> 
> > +       }
> > +
> >         if (nvdimm) {
> >                 struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> >
> > @@ -356,7 +365,7 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
> >                 if (i >= ARRAY_SIZE(handle))
> >                         return -ENXIO;
> >
> > -               switch (cmd) {
> > +               switch (func) {
> >                 case ND_CMD_GET_CONFIG_SIZE:
> >                         rc = nfit_test_cmd_get_config_size(buf, buf_len);
> >                         break;
> > @@ -377,7 +386,7 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
> >                 if (!nd_desc || !test_bit(cmd, &nd_desc->cmd_mask))
> >                         return -ENOTTY;
> >
> > -               switch (cmd) {
> > +               switch (func) {
> >                 case ND_CMD_ARS_CAP:
> >                         rc = nfit_test_cmd_ars_cap(buf, buf_len);
> >                         break;
> 
> This patch is missing setting the ND_CMD_CALL bit in
> 'dimm_dsm_force_en' at the bottom of nfit_test0_setup().  That field
> should also be renamed to 'dimm_cmd_force_en' similar to the dsm_mask
> => cmd_mask rename..


Additionally in acpi_nfit_add_dimm I see:

        nfit_mem->dsm_mask = acpi_desc->dimm_dsm_force_en;


I assume you'll want that changed to:

        nfit_mem->cmd_mask = acpi_desc->dimm_cmd_force_en;



-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
