Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA24F21E87964
 for <linux-nvdimm@lists.01.org>; Tue, 12 Sep 2017 23:31:32 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id D3FE1AC0107
 for <linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 15:34:25 +0900 (JST)
Date: Wed, 13 Sep 2017 15:34:21 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH ndctl] ndctl: sort by dimm's number when bad dimms are
 shown.
In-Reply-To: <CAPcyv4jPKNNYxipHgjTeFPyf6fGhdF2WEr0d5kQEJSYJ23xarA@mail.gmail.com>
References: <20170911113900.17E6.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4jPKNNYxipHgjTeFPyf6fGhdF2WEr0d5kQEJSYJ23xarA@mail.gmail.com>
Message-Id: <20170913153418.245F.E1E9C6FF@jp.fujitsu.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Sun, Sep 10, 2017 at 7:39 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> >> > +
> >> > +   if (!found)
> >> > +           goto err_found;
> >> > +
> >> > +   for (i = 0; i < found; i++) {
> >> > +           const char *devname = ndctl_dimm_get_devname(dimms[i]);
> >> > +
> >> > +           jobj = json_object_new_string(devname);
> >> > +           if (!jobj)
> >> > +                   break;
> >> > +           json_object_array_add(jdimms, jobj);
> >> > +   }
> >>
> >> I have one comment.
> >>
> >> If output is sorted by device number here,
> >> it may be friendly for users.
> >> (Especially, # of interleave way becomes huge in future...)
> >>
> >> Other things are looks good for me.
> >
> > I made a patch to make sorting.
> > I hope it will help....
> >
> > -------
> > To make user friendly, it is desirable that ndctl sorts by dimm's number,
> > when output dimms which have badblocks.
> >
> > Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> >
> > ---
> >  util/json.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/util/json.c b/util/json.c
> > index 9b7773e..dac8692 100644
> > --- a/util/json.c
> > +++ b/util/json.c
> > @@ -366,6 +366,21 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
> >         return NULL;
> >  }
> >
> > +static int compare_dimm_number(const void *p1, const void *p2)
> > +{
> > +       struct ndctl_dimm *dimm1 = *(struct ndctl_dimm **)p1;
> > +       struct ndctl_dimm *dimm2 = *(struct ndctl_dimm **)p2;
> > +       const char *dimm1_name = ndctl_dimm_get_devname(dimm1);
> > +       const char *dimm2_name = ndctl_dimm_get_devname(dimm2);
> > +       int num1, num2;
> > +
> > +       sscanf(dimm1_name, "nmem%d", &num1);
> > +       sscanf(dimm2_name, "nmem%d", &num2);
> > +
> > +       return num1 - num2;
> > +
> > +}
> > +
> >  static struct json_object *badblocks_to_jdimms(struct ndctl_region *region,
> >                 unsigned long long addr, unsigned long len)
> >  {
> > @@ -399,6 +414,8 @@ static struct json_object *badblocks_to_jdimms(struct ndctl_region *region,
> >         if (!found)
> >                 goto err_found;
> >
> > +       qsort(dimms, found, sizeof(dimm), compare_dimm_number);
> > +
> >         for (i = 0; i < found; i++) {
> >                 const char *devname = ndctl_dimm_get_devname(dimms[i]);
> 
> Looks good to me.

I confirmed the most of the patches (and some fixes by you) are
includedin v58. (Thanks a lot!)
But, I noticed that this sorting patch has been not merged yet.

Could you merge this one too?


Bye,


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
