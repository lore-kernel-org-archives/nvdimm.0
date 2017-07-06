Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2347720958977
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jul 2017 16:06:28 -0700 (PDT)
Date: Thu, 6 Jul 2017 19:08:04 -0400
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [RFC v2 0/5] surface heterogeneous memory performance information
Message-ID: <20170706230803.GE2919@redhat.com>
References: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, Robert, Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, devel@acpica.org, "Kogut, Jaroslaw  <Jaroslaw.Kogut@intel.com>, linux-mm@kvack.org, Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, "Lahtinen, Joonas" <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 06, 2017 at 03:52:28PM -0600, Ross Zwisler wrote:

[...]

> =

> =3D=3D=3D=3D Next steps =3D=3D=3D=3D
> =

> There is still a lot of work to be done on this series, but the overall
> goal of this RFC is to gather feedback on which of the two options we
> should pursue, or whether some third option is preferred.  After that is
> done and we have a solid direction we can add support for ACPI hot add,
> test more complex configurations, etc.
> =

> So, for applications that need to differentiate between memory ranges bas=
ed
> on their performance, what option would work best for you?  Is the local
> (initiator,target) performance provided by patch 5 enough, or do you
> require performance information for all possible (initiator,target)
> pairings?

Am i right in assuming that HBM or any faster memory will be relatively sma=
ll
(1GB - 8GB maybe 16GB ?) and of fix amount (ie size will depend on the exact
CPU model you have) ?

If so i am wondering if we should not restrict NUMA placement policy for su=
ch
node to vma only. Forbid any policy that would prefer those node globally at
thread/process level. This would avoid wide thread policy to exhaust this
smaller pool of memory.

Drawback of doing so would be that existing applications would not benefit
from it. So workload where is acceptable to exhaust such memory wouldn't
benefit until their application are updated.


This is definitly not something impacting this patchset. I am just thinking
about this at large and i believe that NUMA might need to evolve slightly
to better handle memory hierarchy.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
