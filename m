Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2DFBC2128DD37
 for <linux-nvdimm@lists.01.org>; Wed, 29 May 2019 11:04:11 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v4 08/10] Documentation/daxctl: add a man page for
 daxctl-reconfigure-device
Date: Wed, 29 May 2019 18:04:08 +0000
Message-ID: <6289acafe92b505cc49590bb789a93c51c081f99.camel@intel.com>
References: <20190528222440.30392-1-vishal.l.verma@intel.com>
 <20190528222440.30392-9-vishal.l.verma@intel.com>
 <CAPcyv4iKz-x4oLjW1=TDByfw9_ergexAGNDpPuTwP-88P_v4=A@mail.gmail.com>
In-Reply-To: <CAPcyv4iKz-x4oLjW1=TDByfw9_ergexAGNDpPuTwP-88P_v4=A@mail.gmail.com>
Content-Language: en-US
Content-ID: <D62E7676619A48458C6AF4DF0FCDDEC1@intel.com>
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


On Wed, 2019-05-29 at 10:49 -0700, Dan Williams wrote:
> On Tue, May 28, 2019 at 3:24 PM Vishal Verma <vishal.l.verma@intel.com
> > wrote:
> > Add a man page describing the new daxctl-reconfigure-device command.
> > 
> > Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  Documentation/daxctl/Makefile.am              |   3 +-
> >  .../daxctl/daxctl-reconfigure-device.txt      | 118
> > ++++++++++++++++++
> >  2 files changed, 120 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/daxctl/daxctl-reconfigure-
> > device.txt
> [..]
> > +-N::
> > +--no-online::
> > +       By default, memory sections provided by system-ram devices
> > will be
> > +       brought online automatically and immediately. Use this
> > option to
> > +       disable the automatic onlining behavior.
> 
> With a --no-online option it feels like we also need a "daxctl
> online-memory" command to hot-add the memory range associated with the
> given dax device. Otherwise, this looks good to me.

Yes good idea, I'll add a command for that. Would we also then need a
complementary offline-memory command? For someone that might want to
split the offlining step from the mode change? I can't imagine a use
case for it..
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
