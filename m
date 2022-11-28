Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8540F8F51
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 15:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669649944; x=1701185944;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=TZk6wcwrVkPB0rocy/KRAy0ihgseKtiw6A/AVOhQYEk=;
  b=H3E60o/EcOzuyAqwPS3yRHch1Fn9B9rBLG+hNMn0iez726u+xIAZqwXT
   nXXiQXM+JSwhR8Ls98iFKNb0tkpWv95vRg4rtRHkoa3Ql/h2e+P9qNDze
   gUHnGwyAxhFzXoystXvqhW1A3xJGlhcaRkHktu0DjnGl63A2QuOKFj9pu
   Xx+Z7XLOzWi1zpZB3Br4VkNz8aS6xcvoBK9RKaKOkE0hDghCyRcpedn4x
   23mjwrSNY42f++R6nlc7OxoIB8w4QzYzOVEdIspR/yIIGNkV3vu0lmuEh
   lbDYRi3m12uzMNtzD1bW8UrBhBzcMFhem6cqZc5AEwvldhkbfBk1lBVII
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="377005171"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="377005171"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 07:36:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="621091015"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="621091015"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.209.161.118]) ([10.209.161.118])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 07:36:24 -0800
Message-ID: <f923dfc0-9cdd-eb61-3480-b8bd595f50ba@intel.com>
Date: Mon, 28 Nov 2022 08:36:23 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [ndctl patch] security.sh: ensure a user keyring is linked into
 the session keyring
Content-Language: en-US
To: Jeff Moyer <jmoyer@redhat.com>, nvdimm@lists.linux.dev
References: <x49a64iq492.fsf@segfault.boston.devel.redhat.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <x49a64iq492.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/22/2022 10:38 AM, Jeff Moyer wrote:
> The restraint test harness is started via a systemd unit file.  In this
> environment, there is no user keyring linked into the session keyring:
> 
> # keyctl show
> Session Keyring
>   406647380 --alswrv      0     0  keyring: _ses
>   148623625 ----s-rv      0     0   \_ user: invocation_id
> 
> As a result, the security.sh test fails.  The logs show:
> 
> ++ keyctl show
> ++ grep -Eo '_uid.[0-9]+'
> ++ head -1
> ++ cut -d. -f2-
> + uid=
> + '[' '' -ne 0 ']'
> /root/rpmbuild/BUILD/ndctl-71.1/test/security.sh: line 245: [: : integer expression expected
> 
> and:
> 
> + keyctl search @u encrypted nvdimm:cdab-0a-07e0-feffffff
> keyctl_search: Required key not available
> + keyctl search @u user nvdimm-master
> keyctl_search: Required key not available
> ++ hostname
> + '[' -f /etc/ndctl/keys/nvdimm_cdab-0a-07e0-feffffff_storageqe-40.sqe.lab.eng.bos.redhat.com.blob ']'
> + setup_keys
> + '[' '!' -d /etc/ndctl/keys ']'
> + '[' -f /etc/ndctl/keys/nvdimm-master.blob ']'
> + '[' -f /etc/ndctl/keys/tpm.handle ']'
> + dd if=/dev/urandom bs=1 count=32
> + keyctl padd user nvdimm-master @u
> ++ keyctl search @u user nvdimm-master
> + keyctl pipe 416513477
> keyctl_read_alloc: Permission denied
> ++ err 47
> +++ basename /root/rpmbuild/BUILD/ndctl-71.1/test/security.sh
> ++ echo test/security.sh: failed at line 47
> ++ '[' -n '' ']'
> ++ exit 1
> 
> To fix this, create a new session keyring and link in the user keyring
> from within the script.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks Jeff!

> 
> diff --git a/test/security.sh b/test/security.sh
> index 34c4977..1aa8488 100755
> --- a/test/security.sh
> +++ b/test/security.sh
> @@ -43,6 +43,9 @@ setup_keys()
>   		backup_handle=1
>   	fi
>   
> +	# Make sure there is a session and a user keyring linked into it
> +	keyctl new_session
> +	keyctl link @u @s
>   	dd if=/dev/urandom bs=1 count=32 2>/dev/null | keyctl padd user "$masterkey" @u
>   	keyctl pipe "$(keyctl search @u user $masterkey)" > "$masterpath"
>   }
> 
> 
