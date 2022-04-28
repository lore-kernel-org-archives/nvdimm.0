Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A344EC2
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 08:51:51 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 711C91F88A;
	Thu, 28 Apr 2022 08:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1651135904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJlbReEahztd0FkC1b41gsYtqvdIadAThBNXtHtAHaQ=;
	b=oRW6E5CswHN9hABWUOgLNlIP9L+7FiCtZZvSLAaOYYRv3FQTt4obLWekKOo6Lha/jWZ3nu
	LGEEFiv8r/iVU8WLlft6XAvot1eV3ktjeuez1mP3ptoSGbnbh8pXG8ZE64cA7Q+3uBmVSm
	VZ/swtxERjsiXzaJHV9irrBfrrL4LPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1651135904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJlbReEahztd0FkC1b41gsYtqvdIadAThBNXtHtAHaQ=;
	b=+lU35ZyVMubP+kUa38il6ZCoXknUkz6shiuL8RVppwgv9sRLP6iyhkqTnrQ/GDgDUsE+bN
	n5rbbhgoeUAhzJBw==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 0DA612C141;
	Thu, 28 Apr 2022 08:51:44 +0000 (UTC)
Date: Thu, 28 Apr 2022 10:51:42 +0200
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: ndctl tests usable?
Message-ID: <20220428085142.GL163591@kunlun.suse.cz>
References: <20220426123839.GF163591@kunlun.suse.cz>
 <CAPcyv4j66HAE_x-eAHQR71pNyR0mk5b463S6OfeokLzZHq5ezw@mail.gmail.com>
 <20220426161435.GH163591@kunlun.suse.cz>
 <CAPcyv4iG4L3rA3eX-H=6nVkwhO2FGqDCbQHB2Lv_gLb+jy3+bw@mail.gmail.com>
 <20220426163834.GI163591@kunlun.suse.cz>
 <CAPcyv4jUj3v+4Sf=1i5EjxTeX9Ur65Smib-vkuaBdKYjUrh7yA@mail.gmail.com>
 <20220426180958.GJ163591@kunlun.suse.cz>
 <d2684252-8c85-ba0e-2356-29837e836f6f@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2684252-8c85-ba0e-2356-29837e836f6f@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Apr 28, 2022 at 10:02:47AM +0530, Shivaprasad G Bhat wrote:
> On 4/26/22 23:39, Michal Suchánek wrote:
> > On Tue, Apr 26, 2022 at 09:47:19AM -0700, Dan Williams wrote:
> > > On Tue, Apr 26, 2022 at 9:43 AM Michal Suchánek <msuchanek@suse.de> wrote:
> > > > 
> > > > On Tue, Apr 26, 2022 at 09:32:24AM -0700, Dan Williams wrote:
> > > > > On Tue, Apr 26, 2022 at 9:15 AM Michal Suchánek <msuchanek@suse.de> wrote:
> > > > > > 
> > > > > > On Tue, Apr 26, 2022 at 08:51:25AM -0700, Dan Williams wrote:
> > > > > > > On Tue, Apr 26, 2022 at 5:39 AM Michal Suchánek <msuchanek@suse.de> wrote:
> > > > > > > > 
> > ...
> > > > > 
> > > > > The modinfo just tells you what modules are available, but it does not
> > > > > necessarily indicate which modules are actively loaded in the system
> > > > > which is what ndctl_test_init() validates.
> > > > 
> > > > Isn't what modinfo lists also what modrobe loads?
> 
> <snip>
> 
> > modules are not loaded before the test.
> > 
> > Maybe something goes wrong with the test module build?
> > 
> > It is very fragile and requires complete kernel source for each
> > configuration built. See below for the package
> > 
> > https://build.opensuse.org/package/show/home:michals/nfit_test
> > 
> > Attaching the log of test run which does not report any missing tools,
> > only complains about nfit.ko being production.
> 
> I have attempted to fix few of the known issues in the first 3 patches of
> the series posted here.
> 
> https://patchwork.kernel.org/project/linux-nvdimm/list/?series=633103

Thanks for pointing out these series.

It is certainly of interest but given the test VM is x86 the papr fixes
don't really apply to this case.

Michal
