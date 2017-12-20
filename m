Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 81E362219BCA5
 for <linux-nvdimm@lists.01.org>; Wed, 20 Dec 2017 08:36:21 -0800 (PST)
Date: Wed, 20 Dec 2017 09:41:07 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Message-ID: <20171220164107.GA29103@linux.intel.com>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <20171214130032.GK16951@dhcp22.suse.cz>
 <20171218203547.GA2366@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171218203547.GA2366@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Anaczkowski, Lukasz" <lukasz.anaczkowski@intel.com>, Moore,Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, Kogut,, "Marcin  <marcin.koss@intel.com>, linux-api@vger.kernel.org, Brice Goglin" <brice.goglin@gmail.com>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 18, 2017 at 01:35:47PM -0700, Ross Zwisler wrote:
> On Thu, Dec 14, 2017 at 02:00:32PM +0100, Michal Hocko wrote:
<>
> > What is the testing procedure? How can I setup qemu to simlate such HW?
> 
> Well, the QEMU table simulation is gross, so I'd rather not get everyone
> testing with that.  Injecting custom HMAT and SRAT tables via initrd/initramfs
> is a much better way:
> 
> https://www.kernel.org/doc/Documentation/acpi/initrd_table_override.txt
> 
> Dan recently posted a patch that lets this happen for the HMAT:
> 
> https://lists.01.org/pipermail/linux-nvdimm/2017-December/013545.html
> 
> I'm working right now on getting an easier way to generate HMAT tables - I'll
> let you know when I have something working.

I've posted details on how to set up test configurations using injected HMAT
and SRAT tables here:

https://github.com/rzwisler/hmat_examples

So far I've got two different sample configs, and we can add more as they are
useful.  Having the sample configs in github is also nice because if someone
finds a config that causes a kernel issue it can be reported then added to
this list of example configs for future testing.

Please let me know if you have trouble getting this working.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
