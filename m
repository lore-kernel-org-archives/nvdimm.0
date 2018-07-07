Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D105920336AD5
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 23:22:02 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2] ndctl, test: add a new unit test for monitor
Date: Sat, 7 Jul 2018 06:21:51 +0000
Message-ID: <1530944509.25150.20.camel@intel.com>
References: <20180706052227.14393-1-qi.fuli@jp.fujitsu.com>
 <a1142e7a-c88c-7ae6-a229-da42dcff405c@gmail.com>
 <5B401C00.6010100@jp.fujitsu.com>
 <CAPcyv4h36Nr7=_ZS8zT9pO-z0sEy2DUXP67-TLwDpO+VP+cvtQ@mail.gmail.com>
In-Reply-To: <CAPcyv4h36Nr7=_ZS8zT9pO-z0sEy2DUXP67-TLwDpO+VP+cvtQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <EA8EC4A26D998D4880E1E461B820AEEE@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2018-07-06 at 20:43 -0700, Dan Williams wrote:
> On Fri, Jul 6, 2018 at 6:48 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> > Hi Masa,
> > 
> > Thank you for your comments.
> > 
> > On 7/7/2018 12:08 AM, Masayoshi Mizuma wrote:
> > > 
> > > Hi Qi,
> > > 
> > > On 07/06/2018 01:22 AM, QI Fuli wrote:
> > > > 
> > > > Add a new unit test to test the following options of the monitor
> > > > command.
> > > >     --dimm
> > > >     --bus
> > > >     --region
> > > >     --namespace
> > > >     --logfile
> > > >     --config-file
> > > > 
> > > > Based-on-patch-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> > > > Acked-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> > > 
> > > I think this Acked-by is wrong because I'm not a maintainer :-)
> > 
> > I'm sorry for this mistake.
> 
> I'm perfectly fine to take reviewed-by's and acked-by's from
> non-maintainers. In fact I'd prefer to have more. I'm sure Vishal
> feels the same.

Yes, absolutely!

> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
