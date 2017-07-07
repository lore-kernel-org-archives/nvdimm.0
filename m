Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate16.nvidia.com (hqemgate16.nvidia.com [216.228.121.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 347B321CB74D2
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jul 2017 22:29:07 -0700 (PDT)
Subject: Re: [RFC v2 0/5] surface heterogeneous memory performance information
References: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <7cb3b9c4-9082-97e9-ebfd-542243bf652b@nvidia.com>
Date: Thu, 6 Jul 2017 22:30:46 -0700
MIME-Version: 1.0
In-Reply-To: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, Robert, Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Lahtinen, Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 07/06/2017 02:52 PM, Ross Zwisler wrote:
[...]
> 
> The naming collision between Jerome's "Heterogeneous Memory Management
> (HMM)" and this "Heterogeneous Memory (HMEM)" series is unfortunate, but I
> was trying to stick with the word "Heterogeneous" because of the naming of
> the ACPI 6.2 Heterogeneous Memory Attribute Table table.  Suggestions for
> better naming are welcome.
> 

Hi Ross,

Say, most of the places (file names, function and variable names, and even
print statements) where this patchset uses hmem or HMEM, it really seems to
mean, the Heterogeneous Memory Attribute Table. That's not *always* true, but
given that it's a pretty severe naming conflict, how about just changing:

hmem --> hmat
HMEM --> HMAT

...everywhere? Then you still have Heterogeneous Memory in the name, but
there is enough lexical distance (is that a thing? haha) between HMM and HMAT
to keep us all sane. :)

With or without the above suggestion, there are a few places (Kconfig, comments,
prints) where we can more easily make it clear that HMM != HMEM (or HMAT), 
so for those I can just comment on them separately in the individual patches.

thanks,
john h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
