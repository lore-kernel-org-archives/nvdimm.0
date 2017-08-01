Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7647321D2DCE8
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 14:02:44 -0700 (PDT)
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: dm: enable opt-out of device-mapper dax support
Date: Tue, 1 Aug 2017 21:04:52 +0000
Message-ID: <1501621491.2475.20.camel@wdc.com>
References: <150161113411.34055.9762658795237184307.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170801190257.GA10033@redhat.com>
 <CAPcyv4jxTQhHANEBmObwhvWW7JHnSmHfCqv3JL3xEm0YFamvrA@mail.gmail.com>
 <CAPcyv4hLP98cap0cgWWw_FOeh9yzLJVSaZURntsB0t2D24nF9Q@mail.gmail.com>
In-Reply-To: <CAPcyv4hLP98cap0cgWWw_FOeh9yzLJVSaZURntsB0t2D24nF9Q@mail.gmail.com>
Content-Language: en-US
Content-ID: <A019DA241164054F93469D0F368F02C8@namprd04.prod.outlook.com>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "agk@redhat.com" <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2017-08-01 at 13:59 -0700, Dan Williams wrote:
> On Tue, Aug 1, 2017 at 12:45 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Tue, Aug 1, 2017 at 12:02 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> > > On Tue, Aug 01 2017 at  2:12pm -0400,
> > > Dan Williams <dan.j.williams@intel.com> wrote:
> > > > [ ... ]
> > > 
> > > I'm questioning the need to have yet another Kbuild CONFIG option.  If
> > > the user has enabled CONFIG_BLK_DEV_PMEM and CONFIG_FS_DAX (DAX already
> > > gets selected by CONFIG_FS_DAX) then shouldn't the DM capabilities just
> > > be enabled?
> > > 
> > > Guess I'm just skeptical of: why do we want to move to a model where
> > > users need to opt-in to DM support for DAX?
> > > 
> > > I also _really_ don't like each target's DAX support being colocated in
> > > drivers/md/dm-dax.c
> > > 
> > > This all looks and feels like a serious step backwards.
> > 
> > Ok, you want ifdef'd sections of DAX code in each target and make
> > DM_DAX a silent option that gets enabled with BLK_DEV_PMEM, anything
> > else?
> 
> Actually, no, I was thrown off by Bart's suggestion to move code
> around. I can handle this all by deleting "select DAX" and adding more
> stubbed out dax helpers.

Hello Mike and Dan,

How about one *-dax.c file per *.c dm file that has to be modified to add DAX support?
I think that approach would avoid collocation of code for different targets in a
single dm-dax.c file and would also avoid that #ifdef CONFIG_DAX statements have to
be added. This approach is orthogonal to removal of CONFIG_DM_DAX.

Thanks,

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
