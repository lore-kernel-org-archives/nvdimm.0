Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174772F25
	for <nvdimm@lists.linux.dev>; Fri, 17 Jun 2022 10:17:59 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 0F6AC21E20;
	Fri, 17 Jun 2022 10:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1655461072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gODh4VPFqTFzZjBKYA28yvBW7WIxELAByjGp5snAP/Y=;
	b=U2u66wewTUFBKmpbN5ynESF/4MchdXX5t2PBwpsTk/DRMaXe92Y1s+ezHVtSMKRfUMt8+r
	DVGsk/nOf0vWzOh8akPNrFUtSzwvWLYWx4awYCmtGNi/8lj7m+h9oEinQqpacPKN/z6xab
	dx+hl/YvBrmE32so8opdmKIEjmZXnUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1655461072;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gODh4VPFqTFzZjBKYA28yvBW7WIxELAByjGp5snAP/Y=;
	b=szCTMbvqWivUIvlSyvCLo3yMTJHevay9nKMSAEsx3x9FP1kPdIGpKuLPVTOdbVx+sRooZI
	V7k78eZMxp/GxqAA==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id EB53C2C141;
	Fri, 17 Jun 2022 10:17:51 +0000 (UTC)
Date: Fri, 17 Jun 2022 12:17:50 +0200
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: nvdimm@lists.linux.dev
Subject: Re: [PATCH] test: monitor: Use in-tree configuration file
Message-ID: <20220617101750.GB4660@kitsune.suse.cz>
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

Yes, very likely. The tests do pass so not failing to not parse the
file is good enough at this point.

> 
> There are two issues here.
> 1) Using the iniparser for parsing the monitor config file
> when the parser is set to parse_monitor_config() for monitor.
> I have posted a patch for this at https://patchwork.kernel.org/project/linux-nvdimm/patch/164750955519.2000193.16903542741359443926.stgit@LAPTOP-TBQTPII8/

Thanks for fixing this. I am not really using the monitor for anything
so I did not notice.

> 
> 2) The directory passed in -c would silently be ignored
> in parse_monitor_config() during fseek() failure. The command proceeds to
> monitor everything.
> 
> Should the -c option be made to accept the directory as argument?

This has been already asked, and as far as I am concerned the answere
remains the same:

The documentation of the -c option talks about files which implies a
directory should be accepted.

This can be resolved either by clarifying the documentation to make it clear
only single file is accepted for -c, or accepting a directory.

Thanks

Michal
