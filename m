Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E67126F14
	for <nvdimm@lists.linux.dev>; Wed,  7 Feb 2024 20:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707336795; cv=none; b=CSJ0lalYMyuZRAWqlmHWtIW39R/MHJXm6qdE90pI0CzZt/2rbhfj07bRQk1eB8q2rOV4JCQBDl0LJRljwsqGdKJVk12qgYKisCUiPOlsHjFGwnAO0dWxev2LZFlo+yDKV6UWsTWMyEiBGYVsoOr9IV67phKOuE8E1gWUpmJv8O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707336795; c=relaxed/simple;
	bh=5IwnW4X5eZGAq3ypHlfqbbuQcAekRcECeINNc1xyf7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W49yBLU/12kkf0q35AYLeWVKhh94qrxa2zHpBWXhRAS7BsKkWi6T6ueBlzzfXY8EyrFZ1z9fUyBbsOfCqDoKoUZi53dg/2Llu6dQlENGI7S1m6yqSTj04bKbF4SSzzOekpi9NkH/UE6SNHwCVxC5IKFhhcEWBuZ4yopEfyqWsao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kbb6yELm; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kbb6yELm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707336792; x=1738872792;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5IwnW4X5eZGAq3ypHlfqbbuQcAekRcECeINNc1xyf7I=;
  b=Kbb6yELmH26wBJov2mJNmXw/OoG8GAlw8QycdvmqQPKipJYSGnCVO/hM
   DrklPokfvO1lmX4ws17/Sof3M2xWqdJDZSat7z0im3wuq8lORb7GLdCrC
   ShhFZ0O/ogv91j5CVzW+zaxgBvhTOmsyPCMSYv9Hh7hgdrfPEgGQ1GJfP
   A0Qx+BrvQxNP/BWwxIMzI2sWQw9bY9UCAFexVnDTdWyQyGqLTLKuGklX6
   ChqQ+rEgWSf79gwcDmi2Vfk/2hftGFy9nksR6PqDDxwlwfZxRl+kr5Uau
   H6X3C5Sr52gIuRZCuQNPdQkYz9u55WzOA7yCs123YzoW1Ygxh8wNlTgEB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="26515037"
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="26515037"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 12:13:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="1742358"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.105.224])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 12:13:11 -0800
Date: Wed, 7 Feb 2024 12:13:09 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com
Subject: Re: [NDCTL PATCH v6 1/4] ndctl: cxl: Add QoS class retrieval for the
 root decoder
Message-ID: <ZcPkVQjK2tXbrvYt@aschofie-mobl2>
References: <20240207172055.1882900-1-dave.jiang@intel.com>
 <20240207172055.1882900-2-dave.jiang@intel.com>
 <ZcPiffSmUyGWC6kB@aschofie-mobl2>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcPiffSmUyGWC6kB@aschofie-mobl2>

On Wed, Feb 07, 2024 at 12:05:17PM -0800, Alison Schofield wrote:
> On Wed, Feb 07, 2024 at 10:19:36AM -0700, Dave Jiang wrote:
> > Add libcxl API to retrieve the QoS class for the root decoder. Also add
> > support to display the QoS class for the root decoder through the 'cxl
> > list' command. The qos_class is the QTG ID of the CFMWS window that
> > represents the root decoder.
> > 
> > Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> 
> -snip-
> 
> > @@ -136,6 +136,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
> >  		param.regions = true;
> >  		/*fallthrough*/
> >  	case 0:
> > +		param.qos = true;
> >  		break;
> >  	}
> 
> Add qos to the -vvv explainer in Documentation/cxl/cxl-list.txt 

My comment is wrong, since it is now an 'always displayed', not a -vvv.
Why put it here at all then? I'm confused!


> 
> 
