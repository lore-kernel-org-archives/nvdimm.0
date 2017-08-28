Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D34121E2BE41
 for <linux-nvdimm@lists.01.org>; Sun, 27 Aug 2017 17:44:57 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id CB055AC02CA
 for <linux-nvdimm@lists.01.org>; Mon, 28 Aug 2017 09:47:28 +0900 (JST)
Date: Mon, 28 Aug 2017 09:47:14 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH 3/3] acpi nfit: nfit_test supports translate SPA
In-Reply-To: <CAPcyv4gz-toh76i=zMLqNpKUX93=7gjTYxwFxAmgaGyKtbq+mg@mail.gmail.com>
References: <20170818135014.8EC5.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4gz-toh76i=zMLqNpKUX93=7gjTYxwFxAmgaGyKtbq+mg@mail.gmail.com>
Message-Id: <20170828094709.9A4F.E1E9C6FF@jp.fujitsu.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Thu, Aug 17, 2017 at 9:50 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> >
> > nfit_test supports translate SPA
> >
> > To test ndctl list which use interface of Translate SPA,
> > nfit_test needs to emulates it.
> > This test module searches region which includes SPA and
> > returns 1 dimm handle which is last one.
> >
> >
> > Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> >
> > ---
> >  drivers/nvdimm/region_devs.c     |  1 +
> >  tools/testing/nvdimm/test/nfit.c | 98 +++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 98 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> > index 5954cfb..3c8cc7f 100644
> > --- a/drivers/nvdimm/region_devs.c
> > +++ b/drivers/nvdimm/region_devs.c
> > @@ -162,6 +162,7 @@ bool is_nd_pmem(struct device *dev)
> >  {
> >         return dev ? dev->type == &nd_pmem_device_type : false;
> >  }
> > +EXPORT_SYMBOL_GPL(is_nd_pmem);
> 
> Only a quick comment here because I need to run, but I'd like to find
> a way to support this without exporting this internal detail. We
> should be able to do this by just looking through the data that
> nfit_test registered with the acpi driver at init time. I'll try to
> think of a more concrete recommendation, but I do want the end
> solution to keep is_nd_pmem private to the libnvdimm core if at all
> possible.
> 

Ok, I'll reconsider it.




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
