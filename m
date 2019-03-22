Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D561F211E8300
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 15:20:16 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id t206so2911317oib.3
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 15:20:16 -0700 (PDT)
MIME-Version: 1.0
References: <155329041583.44801.16828658341038796912.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4jkL0KDuhBTfZN-2GFkvoDQ2G4gDsvpX_cx7TpruDx2Zg@mail.gmail.com>
 <ebe1ac15-e102-da97-3c9e-56113d8638d2@intel.com>
In-Reply-To: <ebe1ac15-e102-da97-3c9e-56113d8638d2@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Mar 2019 15:20:04 -0700
Message-ID: <CAPcyv4jNuoKganpn==DfCnQOzmNxFoEtmZTjXbayFgT_pARYAA@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: security: allow secure erase to execute without
 key
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 22, 2019 at 2:58 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
>
>
> On 3/22/19 2:43 PM, Dan Williams wrote:
> > On Fri, Mar 22, 2019 at 2:33 PM Dave Jiang <dave.jiang@intel.com> wrote:
> >>
> >> Adding support to allow secure erase to happen when security state is not
> >> enabled. Key data of 0's will be passed in.
> >
> > I think I want to change this wording and patch title to say
> > "libnvdimm/security: Support a zero-key for secure-erase". Because we
> > are still passing a key and the kernel interface requires the key-id
> > parameter, we're just arranging for a special key to be used.
> >
> >>
> >> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >> ---
> >>  drivers/nvdimm/security.c        |   17 ++++++++++++-----
> >>  tools/testing/nvdimm/test/nfit.c |    3 +--
> >>  2 files changed, 13 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> >> index f8bb746a549f..b7bd26030964 100644
> >> --- a/drivers/nvdimm/security.c
> >> +++ b/drivers/nvdimm/security.c
> >> @@ -286,8 +286,9 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
> >>  {
> >>         struct device *dev = &nvdimm->dev;
> >>         struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
> >> -       struct key *key;
> >> +       struct key *key = NULL;
> >>         int rc;
> >> +       char *data, dummy_key[NVDIMM_PASSPHRASE_LEN];
> >
> > Let's make this
> >
> > static const char zero_key[NVDIMM_PASSPHRASE_LEN];
> >
> > ...and make it global.
> >
> >>
> >>         /* The bus lock should be held at the top level of the call stack */
> >>         lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
> >> @@ -319,11 +320,17 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
> >>                 return -EOPNOTSUPP;
> >>         }
> >>
> >> -       key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
> >> -       if (!key)
> >> -               return -ENOKEY;
> >> +       if (keyid != 0) {
> >> +               key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
> >> +               if (!key)
> >> +                       return -ENOKEY;
> >> +               data = key_data(key);
> >> +       } else {
> >> +               memset(dummy_key, 0, NVDIMM_PASSPHRASE_LEN);
> >
> > ...with the above change no need to do a memset.
> >
> >> +               data = dummy_key;
> >
> > There may be hardware that actually expects zeroes so I'd rather be
> > explicit, because if it was truly "dummy" there would be no need to
> > initialize it.
> >
> >> +       }
> >>
> >> -       rc = nvdimm->sec.ops->erase(nvdimm, key_data(key), pass_type);
> >> +       rc = nvdimm->sec.ops->erase(nvdimm, (void *)data, pass_type);
> >>         dev_dbg(dev, "key: %d erase%s: %s\n", key_serial(key),
> >>                         pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
> >>                         rc == 0 ? "success" : "fail");
> >> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> >> index b579f962451d..9351a81ea945 100644
> >> --- a/tools/testing/nvdimm/test/nfit.c
> >> +++ b/tools/testing/nvdimm/test/nfit.c
> >> @@ -1059,8 +1059,7 @@ static int nd_intel_test_cmd_secure_erase(struct nfit_test *t,
> >>         struct device *dev = &t->pdev.dev;
> >>         struct nfit_test_sec *sec = &dimm_sec_info[dimm];
> >>
> >> -       if (!(sec->state & ND_INTEL_SEC_STATE_ENABLED) ||
> >> -                       (sec->state & ND_INTEL_SEC_STATE_FROZEN)) {
> >> +       if (sec->state & ND_INTEL_SEC_STATE_FROZEN) {
> >
> > What does this have to do with the new zero-key?
> >
> Because otherwise we will reject the op when security is not enabled.
> The whole point of this was to support secure erase when security is not
> enabled.

I'd rather this be explicitly about accepting zero when the security
state is not enabled. Rather than accepting anything, because we've
seen zero be chosen as a default passphrase in some platforms.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
