Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACBF52122CA87
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 10:38:32 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v3 00/10] daxctl: add a new reconfigure-device
 command
Date: Fri, 17 May 2019 17:38:24 +0000
Message-ID: <ff36c9ecc9073ea39b0a501d8abf5cfc48db388f.camel@intel.com>
References: <20190516224053.3655-1-vishal.l.verma@intel.com>
 <CA+CK2bCEUjCNGHcfqh+4gxtf80eUkz_swNny6A2mkJwLi6Yn+Q@mail.gmail.com>
In-Reply-To: <CA+CK2bCEUjCNGHcfqh+4gxtf80eUkz_swNny6A2mkJwLi6Yn+Q@mail.gmail.com>
Content-Language: en-US
Content-ID: <F0122DCDDDDD4F4E8084F936C8C7A5E4@intel.com>
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

On Fri, 2019-05-17 at 11:30 -0400, Pavel Tatashin wrote:
> On Thu, May 16, 2019 at 6:40 PM Vishal Verma <vishal.l.verma@intel.com
> > wrote:
> > Changes in v3:
> >  - In daxctl_dev_get_mode(), remove the subsystem warning, detect
> > dax-class
> >    and simply make it return devdax
> 
> Hi Vishal,
> 
> I am still getting the same error as before:
> 
> # ndctl create-namespace --mode devdax --map mem -e namespace0.0 -f
> [  141.525873] dax0.0 initialised, 524288 pages in 7ms
> libdaxctl: __sysfs_device_parse: dax0.0: add_dev() failed
> ...
> 
> I am building it via buildroot, and can share the initramfs file or
> anything that can help you with fixing this issue.

Hi Pavel,

I've still not been able to hit this in my testing, is it something you
hit only after applying these patches? i.e. does plain v65 work?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
