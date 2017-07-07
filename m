Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C95821CF25AD
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jul 2017 09:29:18 -0700 (PDT)
Date: Fri, 7 Jul 2017 10:30:58 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFC v2 0/5] surface heterogeneous memory performance information
Message-ID: <20170707163058.GB22856@linux.intel.com>
References: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
 <7cb3b9c4-9082-97e9-ebfd-542243bf652b@nvidia.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7cb3b9c4-9082-97e9-ebfd-542243bf652b@nvidia.com>
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
To: John Hubbard <jhubbard@nvidia.com>
Cc: "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, Robert, Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, "Lahtinen, Joonas" <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 06, 2017 at 10:30:46PM -0700, John Hubbard wrote:
> On 07/06/2017 02:52 PM, Ross Zwisler wrote:
> [...]
> > 
> > The naming collision between Jerome's "Heterogeneous Memory Management
> > (HMM)" and this "Heterogeneous Memory (HMEM)" series is unfortunate, but I
> > was trying to stick with the word "Heterogeneous" because of the naming of
> > the ACPI 6.2 Heterogeneous Memory Attribute Table table.  Suggestions for
> > better naming are welcome.
> > 
> 
> Hi Ross,
> 
> Say, most of the places (file names, function and variable names, and even
> print statements) where this patchset uses hmem or HMEM, it really seems to
> mean, the Heterogeneous Memory Attribute Table. That's not *always* true, but
> given that it's a pretty severe naming conflict, how about just changing:
> 
> hmem --> hmat
> HMEM --> HMAT
> 
> ...everywhere? Then you still have Heterogeneous Memory in the name, but
> there is enough lexical distance (is that a thing? haha) between HMM and HMAT
> to keep us all sane. :)
> 
> With or without the above suggestion, there are a few places (Kconfig, comments,
> prints) where we can more easily make it clear that HMM != HMEM (or HMAT), 
> so for those I can just comment on them separately in the individual patches.
> 
> thanks,
> john h

Hi John,

Sure, that change makes sense to me.  I had initially tried to make this
enabling more generic so that other, non-ACPI systems could use the same sysfs
representation even if they got their performance numbers from some other
source, but while implementing it pretty quickly became very tightly tied to
the ACPI HMAT.

- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
