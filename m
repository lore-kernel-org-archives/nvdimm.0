Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB07035E1AD;
	Mon, 21 Sep 2026 23:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032098; cv=none; b=PWLToe1jde4Y/RLBcTQnyj9/i/jHn4EAaW+67qRzPaqDdakWX7SjOgE63DPUVoBiXr/epWUGpJJsVIbLrIkWtb75AT+BwE/f+hyR2DTGgtbwJXBq5W8Adl7sjM7g6VQAlqWorOzX+PTzzv+YEJSvWigAQNW/HxeQCXVJfiofo6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032098; c=relaxed/simple;
	bh=ji8oFwdNQ8R9jpvDOV+ME55iyNhI7oijUSRvki/noio=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vD7YtvGHSQUvDHeNmVScmkHo7yVpdOi65iPE8m3k/xOzP6ihKfEIleWz3FkPAaD2rWZaFo6DoBgulK2LMYpqoPHntxeglLwEwf9BizXk6uQ/J3i0217YkNNGkNPHjBl9GsZvH0tlzML9EEMFUbyOfTQqlYYu48EGsT7wGtP62Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFIY5AV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFIY5AV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C41D1F000FF;
	Mon, 21 Sep 2026 23:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790032097;
	bh=5JcOJuKfJZM7GVHk2uWmRZzSzlv3iQYRRNPsi5gYUC0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dFIY5AV95wNxw1QilSbvjClIY4zfhmMHlC+q31Ee5gvGVIL6FntCiyVy2uZ3zOgwt
	 v7Y0vktHnBLiauxdJNu0yPSO1DY5ne90m5kENBaiSJV+hINIbC5pHNui1q8MKm4yAI
	 Y6PaNxjs+cZST+pY4WMROvSqRnPcD4/dk8HyUaQEiJVJCUepXkVNsOplTnjCD4WmnC
	 9xXjZXiYcyKsokfMcmRXhyLoIyIHFGtOrQedqohn/5TO8z/zaHZx0tgk9V4kLAU71n
	 fu7eUlmKMr/a2jHXrNF2IGWEoCek7TlGX/WzvcU65S4o8e9C5kY/IX94MpnQTUb1CM
	 PpC6zUhg16bHQ==
Date: Tue, 22 Sep 2026 00:08:13 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 linux-kernel@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [PATCH] dax: use assign_bit() where applicable
Message-ID: <20260922000813.3299a72d@jic23-hlaptop>
In-Reply-To: <34be3233-87a7-4dbd-bf4a-56116f4e8cdb@amd.com>
References: <20260919130750.3041470-1-peng.fan@oss.nxp.com>
	<34be3233-87a7-4dbd-bf4a-56116f4e8cdb@amd.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 21 Sep 2026 10:24:51 +0200
"Gupta, Pankaj" <pankaj.gupta@amd.com> wrote:

> > [You don't often get email from peng.fan@oss.nxp.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> >
> > From: Peng Fan <peng.fan@nxp.com>
> >
> > Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.
> >
> > Signed-off-by: Peng Fan <peng.fan@nxp.com>  
> 
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

A bit marginal wrt to churn but a good change in general.
Up to DAX maintainers on whether they want this type of small
focused improvement.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> 
> > ---
> >   drivers/dax/super.c | 5 +----
> >   1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 45f84b0eb909..60c4aec52ae1 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -385,10 +385,7 @@ EXPORT_SYMBOL_GPL(dax_flush);
> >
> >   void dax_write_cache(struct dax_device *dax_dev, bool wc)
> >   {
> > -       if (wc)
> > -               set_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> > -       else
> > -               clear_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> > +       assign_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags, wc);
> >   }
> >   EXPORT_SYMBOL_GPL(dax_write_cache);
> >
> > --
> > 2.51.0
> >
> >  
> 

