Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF26B17C1
	for <nvdimm@lists.linux.dev>; Mon,  2 May 2022 09:41:41 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id B66C11F894;
	Mon,  2 May 2022 09:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1651484493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s7u5M21GMFBCyjEvPFg8M6d6CNAkK4YrO02l3+jCa0U=;
	b=h/ffWBNBESekmh9QFNr59qE85z+sYgMOULoNv07TFZWI7Ey2Z5+6rzIOVzgOqX9rz2vdEt
	DbrT3W1KIX68J2bN+GeFd+gggZ5WqMcuvhIPnH2KwdraCqY2xOjcSKilUWSnzBH+GDVkyo
	r+W2eTjg5Y9uhdBVbjKtaqm2aPicSVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1651484493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s7u5M21GMFBCyjEvPFg8M6d6CNAkK4YrO02l3+jCa0U=;
	b=Uyul+lnIvsTs9eYnm+7aGDOvHzRBFRqSFhN0Go3foUuAGBx2x03pbhHrBOagZmChOzuDTC
	4owGJf6PraI6ATAg==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id A4E6D2C141;
	Mon,  2 May 2022 09:41:33 +0000 (UTC)
Date: Mon, 2 May 2022 11:41:32 +0200
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: nvdimm@lists.linux.dev
Subject: Re: [PATCH] test: monitor: Use in-tree configuration file
Message-ID: <20220502094132.GO163591@kunlun.suse.cz>
References: <20220428190831.15251-1-msuchanek@suse.de>
 <1fa2de28-7bbb-f584-ec11-2cf320dfea39@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fa2de28-7bbb-f584-ec11-2cf320dfea39@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, May 02, 2022 at 03:03:41PM +0530, Shivaprasad G Bhat wrote:
> On 4/29/22 00:38, Michal Suchanek wrote:
> > When ndctl is not installed /etc/ndctl.conf.d does not exist and the
> > monitor fails to start. Use in-tree configuration for testing.
> > 
> > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >   test/monitor.sh | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/test/monitor.sh b/test/monitor.sh
> > index e58c908..c5beb2c 100755
> > --- a/test/monitor.sh
> > +++ b/test/monitor.sh
> > @@ -13,6 +13,8 @@ smart_supported_bus=""
> >   . $(dirname $0)/common
> > +monitor_conf="$TEST_PATH/../ndctl"
> 
> Though this patch gets the monitor to "listening" mode,
> its not really parsing anything from the $TEST_PATH/../ndctl
> 
> There are two issues here.
> 1) Using the iniparser for parsing the monitor config file
> when the parser is set to parse_monitor_config() for monitor.
> I have posted a patch for this at https://patchwork.kernel.org/project/linux-nvdimm/patch/164750955519.2000193.16903542741359443926.stgit@LAPTOP-TBQTPII8/
> 
> 2) The directory passed in -c would silently be ignored
> in parse_monitor_config() during fseek() failure. The command proceeds to
> monitor everything.
> 
> Should the -c option be made to accept the directory as argument?

The documentation of -c states:

       -c, --config-file=
                  Provide the config file(s) to use. This overrides the
                  default config typically found in /etc/ndctl.conf.d

It is not clear from this description if file or directory is expected.
Given that it suggests multiple files can be provided it implies a
directory is accepted.

Either the description should be clarified or directory accepted.

Thanks

Michal

