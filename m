Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1CF7A2035624F
 for <linux-nvdimm@lists.01.org>; Mon,  4 Dec 2017 16:17:03 -0800 (PST)
Date: Mon, 4 Dec 2017 16:21:33 -0800
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC PATCH 3/4] edac: Add new memory type for non-volatile DIMMs
Message-ID: <20171205002133.2ojkurykvv6zpc4m@agluck-desk>
References: <cover.1512070562.git.tony.luck@intel.com>
 <862104c26398781e4937c3fca3994cbe75d820ff.1512070562.git.tony.luck@intel.com>
 <20171204223711.4l7gbd7op7yvsrza@pd.tnic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171204223711.4l7gbd7op7yvsrza@pd.tnic>
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
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Lv Zheng <lv.zheng@intel.com>, linux-edac@vger.kernel.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 04, 2017 at 11:37:11PM +0100, Borislav Petkov wrote:
> On Thu, Nov 30, 2017 at 12:40:41PM -0800, Tony Luck wrote:
> WTF, there are *two* string arrays with memory types?! How did that
> happen?
> 
> Can you please remove that above in a prepatch and switch to
> edac_mem_types? Or should we switch to this mem_types array instead and
> kill edac_mem_types since former is visible in sysfs?
> 
> :-( Grrr.

Oops. I didn't stare hard enough as I walked the "grep" output
to just blindly add a new case everywhere for the new type.

Need to resolve the differences:
1) MEM_LRDDR3 only appears in one of the tables
2) edac_mem_types[] is exported from edac_mc.c and used
   by two drivers
3) mem_types[] is static in edac_mc_sysfs.c, but values
   are visible to user via sysfs
4) Strings are different between the two :-(

Since the drivers that use edac_mem_types[] only do so in edac_dbg()
output, I think it's safe to declare those strings as the non-canon
ones.

So the plan: copy the strings from mem_types[] to edac_mem_types[]
and then make edac_mc_sysfs.c pick up the exported list from edac_mc.c
instead of having its own static version.

Both files have the same build scope:

edac_core-y     := edac_mc.o edac_device.o edac_mc_sysfs.o

so there shouldn't be any weird dependency problems.

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
