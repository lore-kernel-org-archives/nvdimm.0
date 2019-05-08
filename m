Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B99921243BA0
 for <linux-nvdimm@lists.01.org>; Wed,  8 May 2019 14:04:31 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2 00/10] daxctl: add a new reconfigure-device
 command
Date: Wed, 8 May 2019 21:04:28 +0000
Message-ID: <6efacf297756d97eed37c0377968f5f21abf0448.camel@intel.com>
References: <20190508003851.32416-1-vishal.l.verma@intel.com>
 <CA+CK2bAfOqSK-01wwxZiY=ApjSA7ccuy5K-Xbt1OoHom3Pf6+A@mail.gmail.com>
 <9056dc32dd38be97e96fe07d98076b540cee5db8.camel@intel.com>
In-Reply-To: <9056dc32dd38be97e96fe07d98076b540cee5db8.camel@intel.com>
Content-Language: en-US
Content-ID: <59E08EE041C87948AC8EC90E7C816F81@intel.com>
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
To: "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-05-08 at 20:25 +0000, Verma, Vishal L wrote:
> On Wed, 2019-05-08 at 16:02 -0400, Pavel Tatashin wrote:
> > Hi Vishal,
> > 
> > I am trying to use your changes, and getting the following error:
> > libdaxctl: __sysfs_device_parse: dax0.0: add_dev() failed
> > 
> > Here is full output:
> > # ndctl create-namespace --mode devdax --map mem -e namespace0.0 -f
> > [   26.891054] dax0.0 initialised, 524288 pages in 9ms
> > [   26.894239] random: ndctl: uninitialized urandom read (4 bytes read)
> > libdaxctl: __sysfs_device_parse: dax0.0: add_dev() failed
> > {
> >   "dev":"namespace0.0",
> >   "mode":"devdax",
> >   "map":"mem",
> >   "size":"2046.00 MiB (2145.39 MB)",
> >   "uuid":"6684b3b0-4ab1-45ba-9ce6-48aa046b5fc1",
> >   "daxregion":{
> >     "id":0,
> >     "size":"2046.00 MiB (2145.39 MB)",
> >     "align":2097152
> >   },
> >   "align":2097152
> > }
> 
> Thanks for the report!
> 
> I suspect you may be using the "legacy" device-model. You can
> confirm by seeing if that device even shows up on the "dax" bus.
> Compare /sys/bus/dax/devices/ vs /sys/class/dax/

Hm, I can't reproduce it forcing the dax-class model.
Is this with the qemu config I sent earlier?
Also, could you post the output of ndctl list -BiRND

Thanks,
-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
