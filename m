Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69D052122C312
 for <linux-nvdimm@lists.01.org>; Wed,  8 May 2019 13:25:53 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2 00/10] daxctl: add a new reconfigure-device
 command
Date: Wed, 8 May 2019 20:25:51 +0000
Message-ID: <9056dc32dd38be97e96fe07d98076b540cee5db8.camel@intel.com>
References: <20190508003851.32416-1-vishal.l.verma@intel.com>
 <CA+CK2bAfOqSK-01wwxZiY=ApjSA7ccuy5K-Xbt1OoHom3Pf6+A@mail.gmail.com>
In-Reply-To: <CA+CK2bAfOqSK-01wwxZiY=ApjSA7ccuy5K-Xbt1OoHom3Pf6+A@mail.gmail.com>
Content-Language: en-US
Content-ID: <C759E7ABA2D55742AC805FE7AA32AE74@intel.com>
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


On Wed, 2019-05-08 at 16:02 -0400, Pavel Tatashin wrote:
> Hi Vishal,
> 
> I am trying to use your changes, and getting the following error:
> libdaxctl: __sysfs_device_parse: dax0.0: add_dev() failed
> 
> Here is full output:
> # ndctl create-namespace --mode devdax --map mem -e namespace0.0 -f
> [   26.891054] dax0.0 initialised, 524288 pages in 9ms
> [   26.894239] random: ndctl: uninitialized urandom read (4 bytes read)
> libdaxctl: __sysfs_device_parse: dax0.0: add_dev() failed
> {
>   "dev":"namespace0.0",
>   "mode":"devdax",
>   "map":"mem",
>   "size":"2046.00 MiB (2145.39 MB)",
>   "uuid":"6684b3b0-4ab1-45ba-9ce6-48aa046b5fc1",
>   "daxregion":{
>     "id":0,
>     "size":"2046.00 MiB (2145.39 MB)",
>     "align":2097152
>   },
>   "align":2097152
> }

Thanks for the report!

I suspect you may be using the "legacy" device-model. You can
confirm by seeing if that device even shows up on the "dax" bus.
Compare /sys/bus/dax/devices/ vs /sys/class/dax/

If you see stuff in /sys/class/dax and nothing in
/sys/bus/dax/devices then you need to configure the system to switch
to the device-dax bus-model by running either of the following
commands:

# daxctl migrate-device-model

...or:

# cat <<EOF > /etc/modprobe.d/daxctl.conf
blacklist dax_pmem_compat
alias nd:t7* dax_pmem
EOF

...and then reload the subsystem:

ndctl disable-region all
ndctl enable-region all

That said, if this was the cause, we should improve the failure mode in
this case - I'll look into that, and test by forcing dax-class too.

Thanks,
-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
