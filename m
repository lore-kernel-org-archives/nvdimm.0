Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEEF6FD0
	for <nvdimm@lists.linux.dev>; Wed,  5 Apr 2023 16:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680711226; x=1712247226;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=tytxvQPje9CNNC9oAGhuAfUsP0ygx0dowetWm+5Q59M=;
  b=eovU502ycs2lTsFksXJ5YLJFyUBp6Mj1QFL3SLQQPCcRBgBxgGuy/X7l
   Z0h+QQgf2l6i+hA0HNRW4H3La+QqnCGLIY7QBXYrIAPIlCpRjnvAWnkLF
   UQmXOFejAtYXBctDjsgxiNaqpdTqaFoNBL0CWxazDvt+BzsF98pnIpMnA
   jX/WHf9aiLxwEAli+Nn0f+Ytn3EXSkHk24c02MHTs0ZfxcIUfDOuJa7+g
   0TeneNVV/5NlzbcpEdo5cm605qv5Qri5AvUT3vJRzls5XlIo2QOBS7RTP
   Pe4a3MuAwX22JEKuihn9YMrp1XYpDedHMTr/4N+1DVGGI0zRZhUg++DeW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="405275661"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="405275661"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 09:09:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="751310565"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="751310565"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.183.153]) ([10.213.183.153])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 09:09:19 -0700
Message-ID: <b96cc986-3d89-dfd0-6e55-4a23d74501b7@intel.com>
Date: Wed, 5 Apr 2023 09:09:18 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH ndctl] test/security.sh: Replace cxl with $CXL
Content-Language: en-US
To: Xiao Yang <yangx.jy@fujitsu.com>, nvdimm@lists.linux.dev
References: <1680707060-54-1-git-send-email-yangx.jy@fujitsu.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <1680707060-54-1-git-send-email-yangx.jy@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/5/23 8:04 AM, Xiao Yang wrote:
> Try to avoid the "cxl: command not found" error when
> cxl command is not installed to $PATH.
> 
> Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks for the catch.

> ---
>   test/security.sh | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/test/security.sh b/test/security.sh
> index fb04aa6..4713288 100755
> --- a/test/security.sh
> +++ b/test/security.sh
> @@ -225,7 +225,7 @@ if [ "$uid" -ne 0 ]; then
>   fi
>   
>   modprobe "$KMOD_TEST"
> -cxl list
> +$CXL list
>   setup
>   check_prereq "keyctl"
>   rc=1
