Received: from tartarus.angband.pl (tartarus.angband.pl [51.83.246.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEC170
	for <nvdimm@lists.linux.dev>; Fri,  9 Jul 2021 12:39:18 +0000 (UTC)
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94.2)
	(envelope-from <kilobyte@angband.pl>)
	id 1m1pXR-00CVAh-0N; Fri, 09 Jul 2021 14:23:25 +0200
Date: Fri, 9 Jul 2021 14:23:24 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Anandraj <james.sushanth.anandraj@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, jmoyer <jmoyer@redhat.com>,
	Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Subject: Re: [PATCH v1 0/4] ndctl: Add pcdctl tool with pcdctl list and
 reconfigure-region commands
Message-ID: <YOg/vKafc5PJf/GE@angband.pl>
References: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
 <CAPcyv4iQqL7dGxgN_pSR0Gu27DXX4-d6SNhi2nUs38Mrq+jB=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4iQqL7dGxgN_pSR0Gu27DXX4-d6SNhi2nUs38Mrq+jB=Q@mail.gmail.com>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false

On Thu, Jul 08, 2021 at 02:24:04PM -0700, Dan Williams wrote:
> [ add Jeff, Michal, and Adam ]
> 
> Hey ndctl distro maintainers,
> 
> Just wanted to highlight this new tool submission for your
> consideration. The goal here is to have a Linux native provisioning
> tool that covers the basics of the functionality that is outside of
> the ACPI specification, and reduce the need for ipmctl outside of
> exceptional device-specific debug scenarios. [...]

> I will note that CXL moves the region configuration into the base CXL
> specification so the ndctl project will pick up a "cxl-cli" tool for
> that purpose. [...]

> Please comment on its suitability for shipping in distros alongside
> the ndctl tool.

I see no issues with that.

You might want to suggest whether you prefer pcdctl and clx-cli to be
shipped in a separate binary package.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁ If you ponder doing what Jesus did, remember than flipping tables
⢿⡄⠘⠷⠚⠋⠀ and chasing people with a whip is a prime choice.
⠈⠳⣄⠀⠀⠀⠀
