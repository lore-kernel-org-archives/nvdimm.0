Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <20171214130032.GK16951@dhcp22.suse.cz>
 <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
Date: Wed, 20 Dec 2017 12:22:21 -0800
MIME-Version: 1.0
In-Reply-To: <20171220181937.GB12236@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Matthew Wilcox <willy@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, "Anaczkowski, Lukasz" <lukasz.anaczkowski@intel.com>, "Box, David E" <david.e.box@intel.com>, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, "Koss, Marcin" <marcin.koss@intel.com>, "Koziej, Artur" <artur.koziej@intel.com>, "Lahtinen, Joonas" <joonas.lahtinen@intel.com>, "Moore, Robert" <robert.moore@intel.com>, "Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Odzioba, Lukasz" <lukasz.odzioba@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Schmauss, Erik" <erik.schmauss@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <bsingharora@gmail.com>, Brice Goglin <brice.goglin@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Jerome Glisse <jglisse@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Len Brown <lenb@kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>, devel@acpica.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>

On 12/20/2017 10:19 AM, Matthew Wilcox wrote:
> I don't know what the right interface is, but my laptop has a set of
> /sys/devices/system/memory/memoryN/ directories.  Perhaps this is the
> right place to expose write_bw (etc).

Those directories are already too redundant and wasteful.  I think we'd
really rather not add to them.  In addition, it's technically possible
to have a memory section span NUMA nodes and have different performance
properties, which make it impossible to represent there.

In any case, ACPI PXM's (Proximity Domains) are guaranteed to have
uniform performance properties in the HMAT, and we just so happen to
always create one NUMA node per PXM.  So, NUMA nodes really are a good fit.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
