Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E471EB0F
	for <nvdimm@lists.linux.dev>; Thu,  5 Jan 2023 17:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2C9C433D2;
	Thu,  5 Jan 2023 17:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672940157;
	bh=f7505iY1BWFNhj1WcA6eV90W1WFeuS0jIlveKOJSDFM=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=J+px0FgEMy5oRWTkLUBZEiQ7myhWbq0YAioqxnPvWVRzHuxvMs3I1mfgmTF2ocpz9
	 1QQYvUiB/W0yLU5GwRRQvvMmbcfH27cgw7UUm7/Ljf68J1u8/7P7SW9WBoYpGTatTZ
	 r6Rc+OFlMpusHMESLFoM6mQPK099Rtoyb+scui2TlfjvU1UIm4WCvI2Zyonu2MaDMY
	 5WwBia3Z4JheCYF6RIVb2Re4KmLJVOUi0+edFYQSTAJKYEaXY02Uv8Xkq+EF97sTTf
	 oDWisdJmrwWTVRkr7a+iraA5fmHJihGhwcOwj05Axm/dV0pYfyjhI6J9YkXmr/aMLb
	 +H0RcRoOGP9Ug==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 94C005C0544; Thu,  5 Jan 2023 09:35:56 -0800 (PST)
Date: Thu, 5 Jan 2023 09:35:56 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: rcu@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	rostedt@goodmis.org, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev
Subject: Re: [PATCH rcu 11/27] drivers/dax: Remove "select SRCU"
Message-ID: <20230105173556.GC4028633@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
 <20230105003813.1770367-11-paulmck@kernel.org>
 <63b6ff5c6b954_5178e2945b@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63b6ff5c6b954_5178e2945b@dwillia2-xfh.jf.intel.com.notmuch>

On Thu, Jan 05, 2023 at 08:48:28AM -0800, Dan Williams wrote:
> Paul E. McKenney wrote:
> > Now that the SRCU Kconfig option is unconditionally selected, there is
> > no longer any point in selecting it.  Therefore, remove the "select SRCU"
> > Kconfig statements.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: <nvdimm@lists.linux.dev>
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 
> Let me know if I should pick this up directly, otherwise I assume this
> will go in along with the rest of the set.

Thank you, Dan!  I will apply your ack on my next rebase.  I do plan to
send this along with the rest of the set, but if you do decide to take
it, please just let me know.

							Thanx, Paul
