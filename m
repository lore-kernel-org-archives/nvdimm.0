Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D812C9C
	for <nvdimm@lists.linux.dev>; Fri, 14 Jan 2022 16:55:36 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 591EE21940;
	Fri, 14 Jan 2022 16:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1642179328; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rP52e+p+ikhOCd4h6uXobVshSLpBUbyrgg+vpvUCpbk=;
	b=LktOF4ZRcq1MEBdTdg/4i/48Oj2HFLYo8fSkr2kD+VJ5YMIS6/sTXnymVyFrf5MOR475bF
	H+xbiaLQmQ5SPNUhhB4iCJuiQrJ351kQ10SVgVSUIPbt/0Durlq61xkxit1qSjaSkV3svM
	M+u6vYWfTDnL9wrdPhytBpRWC68rHDw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1642179328;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rP52e+p+ikhOCd4h6uXobVshSLpBUbyrgg+vpvUCpbk=;
	b=Y1usBhmxECa5/pgUKjyDbY2NfwRtKB32UvDmtbNv7LiOdRCehWNVKL7Kk+oQa1qlefXNuD
	8ycIiqWRmryjnwCg==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 2544FA3B81;
	Fri, 14 Jan 2022 16:55:28 +0000 (UTC)
Date: Fri, 14 Jan 2022 17:55:27 +0100
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	"jmoyer@redhat.com" <jmoyer@redhat.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"breno.leitao@gmail.com" <breno.leitao@gmail.com>,
	"vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>,
	"kilobyte@angband.pl" <kilobyte@angband.pl>
Subject: Re: [ndctl PATCH v3 00/16] ndctl: Meson support
Message-ID: <20220114165527.GV134796@kunlun.suse.cz>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
 <d4a57facb2b778867e3bbe8564f03868b58e2f72.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4a57facb2b778867e3bbe8564f03868b58e2f72.camel@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hello,

On Fri, Jan 14, 2022 at 04:04:09PM +0000, Verma, Vishal L wrote:
> On Wed, 2022-01-05 at 13:31 -0800, Dan Williams wrote:
> > Changes since v2 [1]:
> > 
> > - Rebase on v72
> >   - Add Meson support for the new config file directory definitions.
> >   - Add Meson support for landing the daxctl udev rule
> >     daxdev-reconfigure service in the right directories
> > - Include the deprecation of BLK Aperture test infrastructure
> > - Include a miscellaneous doc clarification for 'ndctl update-firmware'
> > - Fix the tests support for moving the build directory out-of-line
> > - Include a fix for the deprectation of the dax_pmem_compat module
> >   pending in the libnvdimm-for-next tree.
> > 
> > [1]: https://lore.kernel.org/r/163061537869.1943957.8491829881215255815.stgit@dwillia2-desk3.amr.corp.intel.com

> Hi Dan,
> 
> These look great, thanks a lot for this work, it is an awesome workflow
> improvement!  I've merged it into pending, and will also merge to
> master shortly to encourage all new submissions to be based on this.
> 
> Also CC'ing a few distro maintainers - this will be a change to
> packaging specs etc. that are maintained outside of the ndctl repo.
> This change can be expected to land in the v73 release, which should be
> in the next 2-4 weeks.

Thanks for the heads-up.

The obvious downside is that with meson build system ndctl is no longer
buildable on older distributions. Then again the new featurees are not
needed there either with old kernels so I don't think this is really a
problem.

https://build.opensuse.org/package/show/home:michals/ndctl.git

Thanks

Michal
