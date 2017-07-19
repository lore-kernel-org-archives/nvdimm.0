Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 10D7D21D0DE60
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 08:23:19 -0700 (PDT)
Subject: Re: [RFC v2 0/5] surface heterogeneous memory performance information
References: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
 <dc224433-3d09-8f2e-d278-fee98ada2afc@huawei.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <0e72ed92-75d0-3fe1-0ab7-ffa069d11b46@intel.com>
Date: Wed, 19 Jul 2017 08:25:13 -0700
MIME-Version: 1.0
In-Reply-To: <dc224433-3d09-8f2e-d278-fee98ada2afc@huawei.com>
Content-Language: en-US
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
To: Bob Liu <liubo95@huawei.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: "Box, David E" <david.e.box@intel.com>, linux-mm@kvack.org, "Zheng, Lv  <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, Robert, Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, "Lahtinen, Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 07/19/2017 02:48 AM, Bob Liu wrote:
>> Option 2: Provide the user with HMAT performance data directly in
>> sysfs, allowing applications to directly access it without the need
>> for the library and daemon.
>> 
> Is it possible to do the memory allocation automatically by the
> kernel and transparent to users? It sounds like unreasonable that
> most users should aware this detail memory topology.

It's possible, but I'm not sure this is something we automatically want
to see added to the kernel.

I look at it like NUMA.  We have lots of details available about how
things are connected.  But, "most users" are totally unaware of this.
We give them decent default policies and the ones that need more can do
so with the NUMA APIs.

These patches provide the framework to help users/apps who *do* care and
want to make intelligent, topology-aware decisions.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
