Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8EEE12020F956
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 14:34:23 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id k18so1343279otr.3
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 14:32:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190828200204.21750-1-vishal.l.verma@intel.com>
 <x49y2zd6obc.fsf@segfault.boston.devel.redhat.com>
 <507921D13093A64EAF066075F3F6ED13076E485E@ORSMSX111.amr.corp.intel.com>
 <1ac1bafeaf3253fb9396c22db334b51deb653f0a.camel@intel.com>
 <ce15fdbdee2135a1b1d698f46d3cc7c9856bb381.camel@intel.com>
In-Reply-To: <ce15fdbdee2135a1b1d698f46d3cc7c9856bb381.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Aug 2019 14:32:12 -0700
Message-ID: <CAPcyv4gnfRv3uKAFj7gctLpZHphCc_3gPc7MzjbYmndK0aZE_w@mail.gmail.com>
Subject: Re: [ndctl RFC PATCH] ndctl/namespace: create namespaces greedily
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Scargall, Steve" <steve.scargall@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 28, 2019 at 2:22 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Wed, 2019-08-28 at 21:16 +0000, Verma, Vishal L wrote:
> > On Wed, 2019-08-28 at 13:47 -0700, Scargall, Steve wrote:
> > > Hi Jeff,
> > >
> > > The issue is more of repetition.   On an 8-socket system,  should a
> > > user really be expected to type 'ndctl create-namespace' eight times
> > > vs. running 'ndctl create-namespace --region=all' once?   SAP HANA is
> > > an example app the requires one namespace per region.  Scripting is a
> > > viable solution, but that requires somebody to write the script and do
> > > all the error checking & handling.  Each OEM/ISV/SysAdmin would have
> > > their own script.  Pushing the logic to ndctl seems to be a reasonable
> > > approach and let the user handle any errors returned by ndctl.
> >
> > A scripted solution can indeed be really simple - e.g.:
> >
> > # while read -r region; do  ndctl create-namespace --region="$region";
> > done < <(ndctl list --bus=nfit_test.0 -R  | jq -r '.[].dev')
> >
> > {
> >   "dev":"namespace5.0",
> >   "mode":"fsdax",
> >   "map":"dev",
> >   "size":"62.00 MiB (65.01 MB)",
> >   "uuid":"c8014457-c268-4f22-8eae-6386fbf08ceb",
> >   "sector_size":512,
> >   "align":2097152,
> >   "blockdev":"pmem5"
> > }
> > {
> >   "dev":"namespace4.0",
> >   "mode":"fsdax",
> >   "map":"dev",
> >   "size":"30.00 MiB (31.46 MB)",
> >   "uuid":"f9498ef6-cdd6-46c7-95f1-86469546ecb9",
> >   "sector_size":512,
> >   "align":2097152,
> >   "blockdev":"pmem4"
> > }
> >
> > > The ndctl-man-page implies the 'ndctl create-namespace --region=all'
> > > feature exists today:
> > >
> > >        -r, --region=
> > >
> > >            A regionX device name, or a region id number. The keyword
> > > all can be specified to carry out the operation on every region in the
> > > system, optionally filtered by bus id (see --bus=  option).
> > >
> >
> > This is true, but unfortunately, the implementation has treated create-
> > namespace as an exception to this since the start, and I agree with Jeff
> > that changing its behavior now can cause other Hyrum's law-esqe [1]
> > breakage.
> >
> > I think however it should be easy to make a compromise, and retain the
> > legacy behavior of create-namespace, while creating a new create-
> > namespace-greedy command with the new semantics.
> >
> .. And it doesn't even need to be a new command, a simple --greedy
> option to create-namespace should be sufficient.

Perhaps "--continue" to proceed with creating namespace after the
first successful invocation. I agree with Jeff that changing the
default semantics would be surprising. The man page can also be fixed
up to make it clear that it's the "singleton region capacity search",
not "all possible namespaces" that "-r all" implies.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
