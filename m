Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EC715AADA;
	Sat,  3 Oct 2026 02:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790993856; cv=none; b=PZBAWor3xbYop9W/1AFAquBw/22pxy32WGFA1s9MNZgr6OGdGaTVkYzir0X0wkEfLPa0LQN/t4wVYLDB4r7/HT9+pp0EJq5tmMxtyCXFluaG1ahGFVtCgi7qWOqJxRNv0BCqQAtMKz8PzuBtpCxntm7fyfKBIOPHI7RQr2Ckcqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790993856; c=relaxed/simple;
	bh=5DPWlIYK+GJls6d6QVtH6QPa3kF5Yz4oyINDw0mwsHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obyb+ko0OmGsmmuj4vq0Fii98OH3Yvo4hxI9Qu32tLW/XKxOfTXYn4p5pRiLo2wfAhvA+FRg1XoJlDsh1lm72zhE3EKaP1xCDwY+FwEYk3lv1o9q0xjGvrbIA9DQ80/ozP/DP717ricBe88oLA7e7sk2VVNw6M+VUrLRgbJhRzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ma0NB00Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ma0NB00Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D581F000FF;
	Sat,  3 Oct 2026 02:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790993855;
	bh=GYVrU3kD803nlbyA/OHE5AVzLTodS+C6PxlHVfoYAcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ma0NB00ZTa8EHSVdZ+zAeoo4VFYhFykdOw/XQeMtfsep/wS/+RyJSwGCy2dLUXBF/
	 4ExlhEDGHruskV77VfbJPXuUNCiwg9peqnFfvrEu4TnHvSXLdSUzRXiYoT5i1ZQ1ww
	 96lChB+aKCtgZc7wjRj0FESOmNT2406akK20PrIiwV53NqHqb9PQuIijO29YOmgWbv
	 Lilq5XeC/K+XQjsgteL7Zz1zxniTZ5IVwV2zeCdUJwzXEkJDwWC5mzqejmLejjR1VB
	 AmPSbPrmP9oSmtLjlUtDllVSWdO6luerdI4vJ19pLUtW8iNIzUHno0z/kt8HJpE3fm
	 hUQWpVXTzTC4Q==
Date: Fri, 2 Oct 2026 19:17:35 -0700
From: Kees Cook <kees@kernel.org>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Bill Wendling <morbo@google.com>, nvdimm@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ira Weiny <iweiny@kernel.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Steven Rostedt <rostedt@goodmis.org>, nikitash.mariiaw@gmail.com,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 10/11] nvdimm: ndtest: Return the string length from
 flags_show()
Message-ID: <20261003021716.e55e62-kees@kernel.org>
References: <20260930235231.out.387-kees@kernel.org>
 <20260930235247.157921-10-kees@kernel.org>
 <ar3yXzo-0k0_BuCD@aschofie-mobl2.lan>
 <ar7vTd282UEZS7XV@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar7vTd282UEZS7XV@aschofie-mobl2.lan>

On Thu, Oct 01, 2026 at 04:39:57PM -0700, Alison Schofield wrote:
> > Should I include this one in a 7.4 PR for nvdimm or is someone else
> > merging the entire series?
>
> NVM, found my answer when trying to build without the entire series.
> Tagging but won't try to merge -

Right, it needs seq_buf_strlen() from earlier in the series, so I'll
take the whole series through my tree. Thanks for the review!

-Kees

-- 
Kees Cook
